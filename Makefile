# Assumes "lyrebirdos" source root is one directory below
ASM = nasm
ASMFLAGS32 = -felf
ASMSRC32 = ../lyrebirdos/boot/kickstart32.s
ASMFLAGS64 = -felf64 
ASMSRC64 = ../lyrebirdos/boot/kickstart64.s

DCOMPILER = gdc

DFLAGS32 = -m32 -gdwarf-2 -nostdlib -fPIC -c 
DFLAGS64 = -m64 -gdwarf-2 -nostdlib -fPIC -c 

DSRC = ../lyrebirdos/kernel/kmain.d


LDLINKER = ld
LDFLAGS32 = -nodefaultlibs -melf_i386 -z max-page-size=0x1000 -T
LDSRC32 = ../lyrebirdos/linker32.ld
LDFLAGS64 = -nodefaultlibs -melf_x86_64 -z max-page-size=0x1000 -T
LDSRC64 = ../lyrebirdos/linker64.ld

OBJS32 = kickstart32.o \
	   kernel32.main.o

OBJS64 = kickstart64.o \
	   kernel64.main.o

rebuild32: clean \
        all32 \
        iso32

rebuild64: clean \
        all46 \
        iso64


image32: kickstart32 \
	kernel32.main \
	linkit32

image64: kickstart64 \
	kernel64.main \
	linkit64


kickstart32:
	$(ASM) $(ASMFLAGS32) -o kickstart32.o $(ASMSRC32)

kickstart64:
	$(ASM) $(ASMFLAGS64) -o kickstart64.o $(ASMSRC64)

kernel32.main:
	$(DCOMPILER) $(DFLAGS32) -o kernel32.main.o $(DSRC)

kernel64.main:
	$(DCOMPILER) $(DFLAGS64) -o kernel64.main.o $(DSRC)

linkit32:
	$(LDLINKER) $(LDFLAGS32) $(LDSRC32) -o kernel32.bin $(OBJS32)

linkit64:
	$(LDLINKER) $(LDFLAGS64) $(LDSRC64) -o kernel64.bin $(OBJS64)

iso32: 
	mkdir iso32/
	mkdir iso32/boot
	cp kernel32.bin iso32/boot/kernel32.bin
	mkdir iso32/boot/grub
	cp ../lyrebirdos/boot/grub.cfg iso32/boot/grub/grub.cfg 
	grub-mkrescue -o lyrebirdos32.iso iso32/

iso64: 
	mkdir iso64/
	mkdir iso64/boot
	cp kernel64.bin iso64/boot/kernel64.bin
	mkdir iso64/boot/grub
	cp ../lyrebirdos/boot/grub.cfg iso64/boot/grub/grub.cfg 
	grub-mkrescue -o lyrebirdos64.iso iso64/

all32: image32 \
	iso32

all64: image64 \
	iso64

clean:
	rm -fr iso*/
	rm -fr *.iso
	rm -fr staging/
	rm *.o *.bin 


