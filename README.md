## Build ISO with grub support and test using qemu

$ make all32

$ qemu-system-i386 -cdrom lyrebirdos32.iso


You should run "make clean" before rebuilding after changes to ensure a clean target

## Makefile targets

rebuild32: clean \
        all32 \
        iso32


image32: kickstart32 \
	kernel32.main \
	linkit32


kickstart32: Build the bootloader ASM

kernel32.main: Build the kernel D source

linkit32: Link bootloader and kernel

iso32: Build an ISO with grub

all32: image32 \
	iso32

clean:
	rm -fr iso*/
	rm -fr *.iso
	rm -fr staging/
	rm *.o *.bin 




