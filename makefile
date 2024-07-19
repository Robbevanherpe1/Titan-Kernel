AS=nasm
CC=i686-elf-gcc
LD=i686-elf-ld
ASFLAGS=-f elf
CFLAGS=-nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs -Wall -Wextra -c
LDFLAGS=-T linker.ld -m elf_i386

ISO_DIR=iso
BOOT_DIR=$(ISO_DIR)/boot
GRUB_DIR=$(BOOT_DIR)/grub

all: os-image

os-image: $(ISO_DIR)/mykernel.iso

$(ISO_DIR)/mykernel.iso: $(BOOT_DIR)/kernel.bin $(GRUB_DIR)/grub.cfg
    grub-mkrescue -o $@ $(ISO_DIR)

$(BOOT_DIR)/kernel.bin: boot/boot.bin kernel/kernel.bin
    cat $^ > $@

$(GRUB_DIR)/grub.cfg:
    mkdir -p $(GRUB_DIR)
    echo 'set timeout=0' > $(GRUB_DIR)/grub.cfg
    echo 'set default=0' >> $(GRUB_DIR)/grub.cfg
    echo 'menuentry "Titan" {' >> $(GRUB_DIR)/grub.cfg
    echo ' multiboot /boot/kernel.bin' >> $(GRUB_DIR)/grub.cfg
    echo ' boot' >> $(GRUB_DIR)/grub.cfg
    echo '}' >> $(GRUB_DIR)/grub.cfg

boot/boot.bin: boot/boot.s
    $(AS) $< -o $@

kernel/kernel.bin: kernel/kernel.o
    $(LD) $(LDFLAGS) -o $@ $<

kernel/kernel.o: kernel/kernel.c
    $(CC) $(CFLAGS) -o $@ $<

clean:
    rm -rf *.bin *.o $(ISO_DIR)/titan.iso
