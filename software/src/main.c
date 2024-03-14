#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <assert.h>
#include <gpiod.h>
#include <getopt.h>
#include "mapper.h"

#define CONSUMER "cobi_interface"
#define MAX_SAMPLES 10000
#define SCAN_CHAIN_DEPTH 504
#define MAX_NUM_PIPES 4
#define MAX_NUM_CHIPS_PER_PIPE 2

uint8_t scan_chain_results[MAX_NUM_CHIPS_PER_PIPE*SCAN_CHAIN_DEPTH][MAX_SAMPLES];

int mem_fd;
volatile uint32_t *scan_bram;
volatile uint32_t *prog_bram;

struct gpiod_chip *chip;
struct gpiod_line *start_scan;
struct gpiod_line *start_prog;
struct gpiod_line *scan_chain_in;
struct gpiod_line *weight_en;
struct gpiod_line *ready_scan;
struct gpiod_line *ready_prog;

int setup_bram(void) {
    // mmap scan chain bram
    mem_fd = open("/dev/mem", O_RDWR | O_SYNC);
    scan_bram = (uint32_t *)mmap(NULL,
            256 * 1024,
            PROT_READ | PROT_WRITE,
            MAP_SHARED,
            mem_fd,
            0xA0000000);
    if (scan_bram == MAP_FAILED) {
        perror("mmap scan failed");
        return 1;
    }

    // mmap programming (weights) bram
    prog_bram = (uint32_t *)mmap(NULL,
            256 * 1024,
            PROT_READ | PROT_WRITE,
            MAP_SHARED,
            mem_fd,
            0xA0100000);
    if (prog_bram == MAP_FAILED) {
        perror("mmap prog failed");
        return 1;
    }

    return 0;
}

void cleanup_bram(void) {
    close(mem_fd);
}

void setup_gpio(void) {
    chip = gpiod_chip_open_by_label("a0200000.gpio");

    // Get GPIO pins
    start_scan = gpiod_chip_get_line(chip, 0);
    start_prog = gpiod_chip_get_line(chip, 1);
    scan_chain_in = gpiod_chip_get_line(chip, 2);
    weight_en = gpiod_chip_get_line(chip, 3);
    ready_scan = gpiod_chip_get_line(chip, 32);
    ready_prog = gpiod_chip_get_line(chip, 33);

    // Set GPIO direction
    gpiod_line_request_output(start_scan, CONSUMER, 0);
    gpiod_line_request_output(start_prog, CONSUMER, 0);
    gpiod_line_request_output(scan_chain_in, CONSUMER, 0);
    gpiod_line_request_output(weight_en, CONSUMER, 1);
    gpiod_line_request_input(ready_scan, CONSUMER);
    gpiod_line_request_input(ready_prog, CONSUMER);
}

void cleanup_gpio(void) {
    // Release GPIO pins
    gpiod_line_release(start_scan);
    gpiod_line_release(start_prog);
    gpiod_line_release(scan_chain_in);
    gpiod_line_release(weight_en);
    gpiod_line_release(ready_scan);
    gpiod_line_release(ready_prog);
}

void program_cobi_chips(unsigned int num_pipes, unsigned int num_chips_per_pipe, char **problems, unsigned int problems_count) {
    assert(num_pipes <= MAX_NUM_PIPES); // Current RTL only does 4 pipes (somewhat easy to change)
    assert(num_chips_per_pipe <= MAX_NUM_CHIPS_PER_PIPE); // Current RTL only does 2 chips per pipe (can be easily changed);

    fprintf(stderr, "Start Programming...\n");

    // Zero out weights in memory
    for (int i = 0; i < 4096*num_chips_per_pipe; i++) {
        prog_bram[i] = 0;
    }

    // Load programming BRAM with graphs
    int problem_index = 0;
    for (int i = 0; i < num_chips_per_pipe; i++) {
        for (int j = 0; j < num_pipes; j++) {
            char *graph_filename = problems[problem_index++];
            int tokens = read_file_to_bram(j, graph_filename, prog_bram + 4096 * i);
            fprintf(stderr, "Read %d tokens from graph %s for COBI chip p%dc%d\n", tokens, graph_filename, j, i);
        }
    }

    // Tell FPGA to prpgram COBI chips
    gpiod_line_set_value(start_prog, 1);
    gpiod_line_set_value(start_prog, 0);

    // Wait for programming to complete
    int ret;
    while (!(ret = gpiod_line_get_value(ready_prog)));
    fprintf(stderr, "Programming Complete!\n");
}

void scan_chain_cobi_chips(unsigned int samples, unsigned int num_pipes, unsigned int num_chips_per_pipe, char **outputs, unsigned int outputs_count) {
    assert(num_pipes <= MAX_NUM_PIPES); // Current RTL only does 4 pipes (can be easily to change)
    assert(num_chips_per_pipe <= MAX_NUM_CHIPS_PER_PIPE); // Current RTL only does 2 chips per pipe (can be easily changed);
    assert(samples <= MAX_SAMPLES);

    // Zero out scan chain results in memory (for sanity, not really needed)
    for (int i = 0; i < SCAN_CHAIN_DEPTH*num_chips_per_pipe; i++) {
        scan_bram[i] = 0;
    }

    fprintf(stderr, "Start Scan Chain Readout...\n");

    for (int sample = 0; sample < samples; sample++) {
        gpiod_line_set_value(scan_chain_in, 1);
        // Randomize spins
        gpiod_line_set_value(weight_en, 0);
        usleep(10);
        gpiod_line_set_value(weight_en, 1);
        usleep(10);

        // Tell FPGA to scan out data
        gpiod_line_set_value(start_scan, 1);
        usleep(1);
        gpiod_line_set_value(start_scan, 0);

        // Wait for scan out to complete
        int ret;
        while (!(ret = gpiod_line_get_value(ready_scan)));

        gpiod_line_set_value(scan_chain_in, 0);

        // Copy data from BRAM for later file storage
        for (int i = 0; i < num_chips_per_pipe*SCAN_CHAIN_DEPTH; i++) {
            scan_chain_results[i][sample] = scan_bram[i] & 0xF;
        }
    }

    fprintf(stderr, "Scan Chain Readout Complete!\n");

    // Write scanchain data to text files
    int output_index = 0;
    for (int i = 0; i < num_chips_per_pipe; i++) {
        for (int j = 0; j < num_pipes; j++) {
            // Write data for each chip (should be same format as RPi Python implementation)
            int node = 62;
            char *filename = outputs[output_index++];
            FILE *fp = fopen(filename, "w");
            fprintf(fp, "node %d:\n", node--);
            for (int bit = 0; bit < SCAN_CHAIN_DEPTH; bit++) {
                if (bit % 8 == 0 && bit != 0) {
                    fprintf(fp, "\nnode %d:\n", node--);
                }
                for (int sample = 0; sample < samples - 1; sample++) {
                    fprintf(fp, "%d   ", (scan_chain_results[bit + SCAN_CHAIN_DEPTH * i][sample] >> j) & 0x1);
                }
                fprintf(fp, "%d\n", (scan_chain_results[bit + SCAN_CHAIN_DEPTH * i][samples - 1] >> j) & 0x1);
            }

            fprintf(stderr, "Wrote Scan Chain Results to %s for COBI chip p%dc%d\n", filename, j, i);
            fclose(fp);
        }
    }

    fprintf(stderr, "Scan Chain File Writing Complete!\n");
}

void print_usage() {
    printf("Usage: program_name -c col -r row -p problems [options]\n");
    printf("Options:\n");
    printf("  -c, --col          <int>   Required: Number of columns\n");
    printf("  -r, --row          <int>   Required: Number of rows\n");
    printf("  -p, --problems     <list>  Required: A problem file to be run, add multiple times\n");
    printf("  -o, --outputs      <list>  Required: An output file to be populated, add multiple\n");
    printf("  -h, --help                 Show this help message\n");
    printf("  --calibration      <list>  Optional: List of calibration files separated by space\n");
    printf("  -s, --samples      <int>   Optional: Number of samples (default: 100)\n");
}

int main(int argc, char **argv) {
    int col = 0, row = 0;
    char **problems = NULL;
    char **outputs = NULL;
    char *calibration = NULL;
    int samples = 100;
    int problems_count = 0;
    int outputs_count = 0;

    struct option long_options[] = {
        {"col", required_argument, NULL, 'c'},
        {"row", required_argument, NULL, 'r'},
        {"problems", required_argument, NULL, 'p'},
        {"outputs", required_argument,NULL, 'o'},
        {"help", no_argument, NULL, 'h'},
        {"calibration", required_argument, NULL, 1000},
        {"samples", required_argument, NULL, 's'},
        {NULL, 0, NULL, 0}
    };

    int opt;
    int option_index = 0;
    while ((opt = getopt_long(argc, argv, "c:r:p:o:hs:", long_options, &option_index)) != -1) {
        switch (opt) {
            case 'c':
                col = atoi(optarg);
                break;
            case 'r':
                row = atoi(optarg);
                break;
            case 'p':
                problems_count++;
                problems = realloc(problems, problems_count * sizeof(char *));
                problems[problems_count - 1] = optarg;
                break;
            case 'o':
                outputs_count++;
                outputs = realloc(outputs, outputs_count * sizeof(char *));
                outputs[outputs_count - 1] = optarg;
                break;
            case 'h':
                print_usage();
                return 0;
            case 1000:
                calibration = optarg;
                break;
            case 's':
                samples = atoi(optarg);
                break;
            case '?':
            default:
                print_usage();
                return 1;
        }
    }

    if (col == 0 || row == 0 || problems == NULL || outputs == NULL) {
        print_usage();
        return 1;
    }

    if (problems_count != outputs_count) {
        fprintf(stderr, "The number of output files must be equal to the number of problems.\n");
        return 1;
    }

    setup_bram();
    setup_gpio();

    program_cobi_chips(col, row, problems, problems_count);
    scan_chain_cobi_chips(samples, col, row, outputs, outputs_count);

    cleanup_gpio();
    cleanup_bram();

    free(problems);
    free(outputs);

    return 0;
}
