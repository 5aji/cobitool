 building this image requires petalinux to be installed.
 it can be downloaded here:
 https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html

to build (skip steps 1-3 if reflashing prebuilt image):
 1. run petalinux-build
 2. run petalinux-package --boot --u-boot
 3. run petalinux-package --wic
 4. find the image in images/linux/*.wic
 5. run `sudo dd bs=1M status=progress if=petalinux-sdimage.wic of=/dev/<sd card device> conv=fsync`
 6. wait for completion and remove card when finished
 7. set the boot switches to 1000 (mode0,mode1,mode2,mode3) to boot from sd card. 
 8. device should come up. If an ethernet cable is plugged in, the system should also acquire an IP address.
 9. Either use nmap to scan the local network or read the IP using `ip link a` on the USB Shell. You can ssh to the device's IP once it's started up.
 10. The default username and password is `petalinux:password`


 To get access to the shell, connect to the USB serial port. The device exposes several different ports, but only
 the first one is attached to the OS. Use 115200 as the baudrate and defaults for everything else. If it
 works, a bootup sequence should display when the switch is powered on.

 NOTE: the usb serial can be set up even when the system is not powered, letting you see everything from the moment
 it powers on.
