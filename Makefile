# Assumes "lyrebirdos" source root is one directory below
ASM = nasm
ASMFLAGS32 = -felf
ASMSRC32 = ../lyrebirdos/boot/kickstart32.s

#DCOMPILER = gdc
#DFLAGS32 = -m32 -gdwarf-2 -nostdlib -fPIC -c 

DCOMPILER = dmd
DFLAGS32 = -m32 -g -c

DSRC = ../lyrebirdos/kernel/kmain.d


LDLINKER = ld
LDFLAGS32 = -nodefaultlibs -melf_i386 -z max-page-size=0x1000 -T
LDSRC32 = ../lyrebirdos/linker32.ld

OBJS32 = kickstart32.o \
	   kernel32.main.o


rebuild32: clean \
        all32 \
        iso32


image32: kickstart32 \
	kernel32.main \
	linkit32


kickstart32:
	$(ASM) $(ASMFLAGS32) -o kickstart32.o $(ASMSRC32)

kernel32.main:
	$(DCOMPILER) $(DFLAGS32) -ofkernel32.main.o $(DSRC)

linkit32:
	$(LDLINKER) $(LDFLAGS32) $(LDSRC32) -o kernel32.bin $(OBJS32)

iso32: 
	mkdir iso32/
	mkdir iso32/boot
	cp kernel32.bin iso32/boot/kernel32.bin
	mkdir iso32/boot/grub
	cp ../lyrebirdos/boot/grub.cfg iso32/boot/grub/grub.cfg 
	grub-mkrescue -o lyrebirdos32.iso iso32/


all32: image32 \
	iso32

clean:
	rm -fr iso*/
	rm -fr *.iso
	rm -fr staging/
	rm *.o *.bin 


