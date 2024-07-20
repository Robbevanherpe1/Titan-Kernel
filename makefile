# Target
TARGET = kernel.bin

# Directories
ISO_DIR = iso
BOOT_DIR = boot
KERNEL_DIR = kernel

# Compiler and linker
CC = gcc
ASM = nasm
LD = ld
CFLAGS = -m32 -ffreestanding -fno-pic -fno-pie
LDFLAGS = -m elf_i386 -T $(KERNEL_DIR)/linker.ld

# Build rules
all: $(ISO_DIR)/Titan.iso

$(ISO_DIR)/boot/$(TARGET): $(BOOT_DIR)/boot.o $(KERNEL_DIR)/kernel.bin
	@mkdir -p $(ISO_DIR)/boot
	cp $(KERNEL_DIR)/kernel.bin $(ISO_DIR)/boot/$(TARGET)

$(BOOT_DIR)/boot.o: $(BOOT_DIR)/boot.asm
	$(ASM) -f elf32 -o $(BOOT_DIR)/boot.o $(BOOT_DIR)/boot.asm

$(KERNEL_DIR)/kernel.o: $(KERNEL_DIR)/kernel.c
	$(CC) $(CFLAGS) -c $(KERNEL_DIR)/kernel.c -o $(KERNEL_DIR)/kernel.o

$(KERNEL_DIR)/idt_load.o: $(KERNEL_DIR)/idt_load.asm
	$(ASM) -f elf32 -o $(KERNEL_DIR)/idt_load.o $(KERNEL_DIR)/idt_load.asm

$(KERNEL_DIR)/kernel.bin: $(KERNEL_DIR)/kernel.o $(KERNEL_DIR)/idt_load.o $(BOOT_DIR)/boot.o
	$(LD) $(LDFLAGS) -o $(KERNEL_DIR)/kernel.bin $(BOOT_DIR)/boot.o $(KERNEL_DIR)/kernel.o $(KERNEL_DIR)/idt_load.o

$(ISO_DIR)/boot/grub/grub.cfg:
	@mkdir -p $(ISO_DIR)/boot/grub
	echo 'set timeout=5' > $(ISO_DIR)/boot/grub/grub.cfg
	echo 'set default=0' >> $(ISO_DIR)/boot/grub/grub.cfg
	echo 'menuentry "Titan Kernel" {' >> $(ISO_DIR)/boot/grub/grub.cfg
	echo '    multiboot /boot/$(TARGET)' >> $(ISO_DIR)/boot/grub/grub.cfg
	echo '    boot' >> $(ISO_DIR)/boot/grub/grub.cfg
	echo '}' >> $(ISO_DIR)/boot/grub/grub.cfg

$(ISO_DIR)/Titan.iso: $(ISO_DIR)/boot/$(TARGET) $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO_DIR)/Titan.iso $(ISO_DIR)

clean:
	rm -rf $(ISO_DIR) $(BOOT_DIR)/*.o $(KERNEL_DIR)/*.o $(KERNEL_DIR)/*.bin

run: $(ISO_DIR)/Titan.iso
	qemu-system-i386 -cdrom $(ISO_DIR)/Titan.iso -d int,cpu_reset -no-reboot -no-shutdown -monitor stdio
