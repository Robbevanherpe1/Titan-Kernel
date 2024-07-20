#include <stdint.h>

#define IDT_SIZE 256

// IDT entry structure
struct idt_entry {
    uint16_t base_lo;
    uint16_t sel;
    uint8_t always0;
    uint8_t flags;
    uint16_t base_hi;
} __attribute__((packed));

struct idt_ptr {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

struct idt_entry idt[IDT_SIZE];
struct idt_ptr idtp;  // Define idtp

extern void idt_load(); // Defined in assembly

void idt_set_gate(uint8_t num, uint32_t base, uint16_t sel, uint8_t flags) {
    idt[num].base_lo = base & 0xFFFF;
    idt[num].base_hi = (base >> 16) & 0xFFFF;
    idt[num].sel = sel;
    idt[num].always0 = 0;
    idt[num].flags = flags;
}

void idt_install() {
    idtp.limit = (sizeof(struct idt_entry) * IDT_SIZE) - 1;
    idtp.base = (uint32_t)&idt;
    for (int i = 0; i < IDT_SIZE; i++) {
        idt_set_gate(i, 0, 0, 0);
    }
    idt_load(); // Load IDT with the assembly instruction lidt
}

void clear_screen() {
    char *vidptr = (char*)0xb8000;  // video memory begins here.
    unsigned int i = 0;
    while (i < 80 * 25 * 2) {       // 80 columns * 25 rows * 2 bytes per character
        vidptr[i++] = ' ';          // character byte
        vidptr[i++] = 0x07;         // attribute byte: light grey on black background
    }
}

void kernel_main() {
    idt_install(); // Initialize IDT
    clear_screen(); // Clear the screen

    const char *str = "Hello, World!";
    char *vidptr = (char*)0xb8000;  // video memory begins here.
    unsigned int i = 0;
    unsigned int j = 0;

    while (str[j] != '\0') {
        vidptr[i++] = str[j++];
        vidptr[i++] = 0x07;  // attribute-byte: light grey on black screen
    }

    //asm volatile ("sti"); // Enable interrupts

    while (1); // Hang
}
