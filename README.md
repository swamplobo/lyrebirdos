## Build ISO with grub support and test using qemu

$ make clean

$ make all

$ make iso

$ qemu-system-i386 -cdrom lyrebirdos.iso


See the Makefile for more details on each make target.
