#!/bin/sh

if [ -z "$1" ]
then
echo "missing bitstream argument"
echo "usage: load_fpga.sh <bitstream>"
exit 1
fi


sudo fpgautil -R
sudo fpgautil -b /lib/firmware/xilinx/base/mpsoc_preset_wrapper.bit.bin -o /lib/firmware/xilinx/base/base.dtbo
sudo fpgautil -b $1
