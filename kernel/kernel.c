#include <stdint.h>
#include <idt.h>
#include <io.h>
#include <keyboard.h>

#define IDT_SIZE 256

struct idt_entry idt[IDT_SIZE];
struct idt_ptr idtp;  // Define idtp

extern void idt_load(); // Defined in assembly

volatile char last_key = 0;

// Keyboard handler main function
void keyboard_handler_main() {
    uint8_t scancode = inb(0x60);
    last_key = scancode_to_char(scancode);
    outb(0x20, 0x20); // Send End of Interrupt (EOI) signal
}

char scancode_to_char(uint8_t scancode) {
    switch (scancode) {
        case 0x02: return '1';
        case 0x03: return '2';
        case 0x04: return '3';
        case 0x05: return '4';
        case 0x06: return '5';
        case 0x07: return '6';
        case 0x08: return '7';
        case 0x09: return '8';
        case 0x0A: return '9';
        case 0x0B: return '0';
        case 0x1E: return 'a';
        case 0x30: return 'b';
        case 0x2E: return 'c';
        case 0x20: return 'd';
        case 0x12: return 'e';
        case 0x21: return 'f';
        case 0x22: return 'g';
        case 0x23: return 'h';
        case 0x17: return 'i';
        case 0x24: return 'j';
        case 0x25: return 'k';
        case 0x26: return 'l';
        case 0x32: return 'm';
        case 0x31: return 'n';
        case 0x18: return 'o';
        case 0x19: return 'p';
        case 0x10: return 'q';
        case 0x13: return 'r';
        case 0x1F: return 's';
        case 0x14: return 't';
        case 0x16: return 'u';
        case 0x2F: return 'v';
        case 0x11: return 'w';
        case 0x2D: return 'x';
        case 0x15: return 'y';
        case 0x2C: return 'z';
        case 0x39: return ' ';
        default: return 0;
    }
}

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

    // Simulate running a user-space application
    void (*user_app)() = (void (*)())0x00110000; // Assume user_app is loaded at 0x00110000
    user_app();

    while (1) {
        if (last_key != 0) {
            vidptr[i++] = last_key;
            vidptr[i++] = 0x07; // attribute-byte: light grey on black screen
            last_key = 0;
        }
    }

    while (1); // Hang
}
