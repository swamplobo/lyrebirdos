## Build ISO with grub support and test using qemu

$ make iso32

$ qemu-system-i386 -cdrom lyrebirdos.iso


See the Makefile for more details on each make target. You should run "make clean" before rebuilding after changes to ensure a clean target



