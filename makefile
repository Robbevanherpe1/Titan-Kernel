all: iso/Titan.iso

iso/boot/bootloader.bin: boot/bootloader.o boot/pmode.o kernel/kernel.o
	@mkdir -p iso/boot
	ld -m elf_i386 -T linker.ld --oformat binary -o iso/boot/bootloader.bin boot/bootloader.o boot/pmode.o kernel/kernel.o

boot/bootloader.o: boot/bootloader.s
	nasm -f elf32 -o boot/bootloader.o boot/bootloader.s

boot/pmode.o: boot/pmode.s
	nasm -f elf32 -o boot/pmode.o boot/pmode.s

kernel/kernel.o: kernel/kernel.c
	@mkdir -p iso
	gcc -m32 -ffreestanding -fno-pic -fno-pie -c kernel/kernel.c -o kernel/kernel.o

iso/Titan.iso: iso/boot/bootloader.bin
	@mkdir -p iso
	genisoimage -R -b boot/bootloader.bin -no-emul-boot -boot-load-size 4 -boot-info-table -o iso/Titan.iso iso

clean:
	rm -rf iso/boot/bootloader.bin kernel/kernel.o boot/*.o iso