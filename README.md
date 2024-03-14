# EE4951W Quantum Inspired Interface

This is the github repo for the EE senior design project in S23 at University of Minnesota.
The project sponsor is Prof. Chris Kim and is named Quantum Inspired Computing: Interfacing and Algorithms.
The project members are: Carl Anderson, Saji Champlin, Nathan Gallagher, Alex Skauge, and Jack Sweeney.

This repo is structured into directories by filetype:

* `py` contains old RPi Python code, weight graph generation scripts, and histogram graph generation script for results
* `rtl` contains generic Verilog RTL files for programming and scan chain controllers
* `cobi_interface_vivado` contains a Vivado 2022.2 project for the ZCU104 development board which links to the RTL
  and contains glue logic for the controller and the AXI bus for the Linux side
* `sim` contains the testbench for the generic RTL for use with any System Verilog simulator (used Icarus Verilog. note: not set in the Vivado project)
* `linux` contains the petalinux project for the Linux image on the ARM-side of the ZCU104
* `software` contains the C software that runs in Linux on the ARM core for communication with the FPGA
* `Altium` for Altium Designer PCB files of the FMC board

# Usage


## Building the image

This step is *optional*, since an SD Card image is provided.

1. Synthesize/PnR the RTL for the FPGA using the provided Vivado project. Take the bitstream binary output
2. Build the C code using a cross-compiler for the ZCU104 using the provided Makefile and sdk.sh in the drive zip.
3. Build Linux image using petalinux and flash the image to the SD card of the ZCU104. See `linux/readme_building.txt` for details on how to do this.
    * Alternatively, use the prebuilt image. Make sure the DIP switches on the ZCU104 are set for SD boot. We recommend using the prebuilt image.
    * The prebuilt image can be written to an SD card using tools like Balena Etcher or `dd`. Any "Disk imager" will work.
4. Connect to the ZCU104 using the micro USB port. It will appear as several serial ports. [More detail here.](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842446/Setup+a+Serial+Console)
5. Connect the ZCU104 to the network using the Ethernet port. The IP address can be seen by using `ip link a` on the serial console.
6. You can remotely access the ZCU104 by using SSH.

## Connecting and running a graph.
1. Copy the bitstream, the C program `cobitool`, and the weight graphs (can be generated using `py/create_graph.py`) to the SD card's Linux root
    * This can be done before booting the image by mounting the partition on a Linux system or after by copying over SSH with SCP.
    * `scp -O <local_file> <ip_of_zcu104>:<destination>`.
    * You can swap the local file and the zcu104 ip to instead download a file from the zcu104.
2. Load the bitstream into the FPGA using the `load_fpga.sh` script. The `load_fpga.sh` script takes a single bitstream file as its argument.
3. Run `cobitool` with the desired network settings and weight files
    * This must be run as `root` via `sudo` or otherwise
4. Copy the resultant scan chain output files to your PC for later analysis
    * Similarly, this can be done after shutting down the ZCU104 by mounting the partition on a Linux system or during operation by copying over SSH with SCP
5. The results can easily be analyzed using `py/hamiltonian_histogram.py <weights.txt> <scanchain.txt>` which generates a histogram of the chip's results, random spin's results (for reference), and the true solution determined by software
    * This script requires Python 3.10 (not newer), `dwave-qbsolv`, `matplotlib`, and `numpy`

# `cobitool` Examples

```
sudo ./cobitool -c 1 -r 1 -p weights_prob1.txt -o scanout_prob1.txt
```
This programs a single chip in first position with the weights in `weights_prob1.txt` and stores 100 samples of results (the default) in
`scanout_prob1.txt`

---

```
sudo ./cobitool -c 4 -r 1 -p weights_prob1.txt -p weights_prob2.txt -p weights_prob3.txt -p weights_prob4.txt -o scanout_prob1.txt -o scanout_prob2.txt -o scanout_prob3.txt -o scanout_prob4.txt -s 10000
```
This programs 4 chips in parallel in a 4 by 1 network with 4 different weight problems with 10000 samples each being stored in separate results files.

---

```
sudo ./cobitool -c 2 -r 2 -p weights_prob1.txt -p weights_prob2.txt -p weights_prob3.txt -p weights_prob4.txt -o scanout_prob1.txt -o scanout_prob2.txt -o scanout_prob3.txt -o scanout_prob4.txt -s 10
```
This programs 4 chips (2 at a time) in a 2 by 2 network with 4 different weight problems with 10 samples each being stored in separate results files.
See the note below about potential issues in `cobitool` for networks with depth >1. The order of the outputs may be scrambled somewhat i.e. `scanout_prob1.txt` may actaully contain the results of the chip with `weighs_prob3.txt`. This issue could not be verified/tested/fixed since a network was never actually constructed.


# Notes

* This system has only been tested for a single COBI chip but should function for up to eight COBI chips in a network. The RTL and software is designed/built to support eight chips with no changes at all. Larger network support can be easily added by changing the top-level parameters in the RTL and C code
* The C code probably has a bug where COBI chips in the same pipe have their outputs ``reversed'' within the pipe. i.e. the results of the chip at the end of the pipe will be stored in the file for the first pipe and vice-versa. This doesn't affect single depth pipe networks and thus couldn't be verified/fixed
* The C software does not currently support COBI chip calibration. Calibration can be included directly inside the graph files instead
* The input and output formats should match that of the old RPi based system
* The biggest performace bottleneck is file IO in the C program. A more efficient file format or in-program processing could fix this
