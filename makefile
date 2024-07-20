all: iso/Titan.iso

iso/boot/bootloader.bin: boot/bootloader.o boot/pmode.o kernel/kernel.o
	@mkdir -p iso/boot
	ld -m elf_i386 -Ttext 0x7c00 --oformat binary -o iso/boot/bootloader.bin boot/bootloader.o boot/pmode.o kernel/kernel.o

boot/bootloader.o: boot/bootloader.s
	nasm -f elf32 -o boot/bootloader.o boot/bootloader.s

boot/pmode.o: boot/pmode.s
	nasm -f elf32 -o boot/pmode.o boot/pmode.s

kernel/kernel.o: kernel/kernel.c
	@mkdir -p iso
	gcc -m32 -ffreestanding -fno-pic -fno-pie -c kernel/kernel.c -o kernel/kernel.o

iso/boot/grub/grub.cfg: 
	@mkdir -p iso/boot/grub
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo 'menuentry "Titan Kernel" {' >> iso/boot/grub/grub.cfg
	echo '    multiboot /boot/bootloader.bin' >> iso/boot/grub/grub.cfg
	echo '    boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg

iso/Titan.iso: iso/boot/bootloader.bin iso/boot/grub/grub.cfg
	grub-mkrescue -o iso/Titan.iso iso

clean:
	rm -rf iso boot/*.o kernel/*.o kernel/kernel.bin

run: iso/Titan.iso
	qemu-system-i386 -cdrom iso/Titan.iso
