AS=nasm
CC=i686-elf-gcc
LD=i686-elf-ld
ASFLAGS=-f bin
CFLAGS=-nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs -Wall -Wextra -c
LDFLAGS=-T linker.ld -m elf_i386

ISO_DIR=iso
BOOT_DIR=$(ISO_DIR)/boot
GRUB_DIR=$(BOOT_DIR)/grub

all: titan.iso

titan.iso: $(ISO_DIR)/titan.iso

$(ISO_DIR)/titan.iso: $(BOOT_DIR)/boot.bin $(BOOT_DIR)/kernel.bin $(GRUB_DIR)/grub.cfg
	mkdir -p $(ISO_DIR)
	grub-mkrescue -o $@ $(ISO_DIR)

$(BOOT_DIR)/boot.bin: boot/boot.s
	mkdir -p $(BOOT_DIR)
	$(AS) $(ASFLAGS) -o $@ $<

$(BOOT_DIR)/kernel.bin: kernel/kernel.bin
	mkdir -p $(BOOT_DIR)
	cat $(BOOT_DIR)/boot.bin $(BOOT_DIR)/kernel.bin > $@

$(GRUB_DIR)/grub.cfg:
	mkdir -p $(GRUB_DIR)
	echo 'set timeout=0' > $(GRUB_DIR)/grub.cfg
	echo 'set default=0' >> $(GRUB_DIR)/grub.cfg
	echo 'menuentry "Titan" {' >> $(GRUB_DIR)/grub.cfg
	echo ' multiboot /boot/kernel.bin' >> $(GRUB_DIR)/grub.cfg
	echo ' boot' >> $(GRUB_DIR)/grub.cfg
	echo '}' >> $(GRUB_DIR)/grub.cfg

kernel/kernel.bin: kernel/kernel.o
	$(LD) $(LDFLAGS) -o $@ $<

kernel/kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf *.bin *.o $(ISO_DIR)/titan.iso
