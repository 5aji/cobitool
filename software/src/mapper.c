#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>



static const uint8_t weight_lut[17] = {
    0b111110, // -8, strong negative coupling.
    0b001110, // -7
    0b001100, // -6
    0b001010, // -5
    0b001000, // -4
    0b000110, // -3
    0b000100, // -2
    0b000010, // -1
    0b000000, // zero
    0b000011, // 1
    0b000101, // 2
    0b000111, // 3
    0b001001, // 4
    0b001011, // 5
    0b001101, // 6
    0b001111, // 7
    0b011111  // 8
};
const uint8_t diag_value = 0b011111;
// returns a 6-bit weight value based on the array input value and position.
// if it's a diagonal, it sets it to the correct diagonal entry.
uint8_t map_pin(int row, int col, int raw_value) {
    // todo: graphs have the correct value?
    if (row == 63 - col) {
        return diag_value; // diagonal fast-path.
    }
    if (raw_value > 8 || raw_value < -8) {
        printf("invalid graph input: %d\n", raw_value);
        exit(-1);
    }
    // now, we cheat, and add +8 to the raw_value, then we use this to index into the LUT.

    return weight_lut[raw_value + 8];
}


// this function takes a pipe index, filename, and a destination.
// it reads the problem, maps it, and then puts the problem into the memory pointed to by dest.
// pipe controls the offset in the 32-bit word. i,e pipe=0 shifts zero, pipe = 1 shifts 6 bits, etc.

int read_file_to_bram(int pipe, char* filename, volatile uint32_t* dest) {
    char source[50000]; // plenty big lmao.

    FILE *fp = fopen(filename, "r");
    if (fp == NULL) {
        perror("error opening file.");

        exit(1);
    }
    size_t s = fread(source, sizeof(char), 50000, fp);
    source[s++] = '\0';
    
    const char *delimiters = " \t\n";

    char* field;
    char* head = &source[0];
    unsigned int token_idx = 0; // which token we have processed.
    // to get col: token_idx % 64
    // to get row, token_idx / 64
    // todo: strtol
    while ((field = strsep(&head, delimiters)) != NULL) {
        if (*field == '\0') {
            continue; // double delimiter, skip it.
        }

        int row = token_idx / 64;
        int col = token_idx % 64;

        // scan the field value out.
        int val = atoi(field);
        // map it.
        uint8_t mapped_val = map_pin(row, col, val);

        // or equals so that we can write higher pipe values later.
        // assume it's been cleared by the caller.
        dest[(row << 6) | col] |= mapped_val << (6 * pipe);

        // go next
        token_idx++;
    }
    fclose(fp);
    return token_idx;
}