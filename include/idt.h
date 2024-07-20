#ifndef _IDT_H
#define _IDT_H

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

// IDT pointer structure
struct idt_ptr {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

// IDT functions
void idt_set_gate(uint8_t num, uint32_t base, uint16_t sel, uint8_t flags);
void idt_install();

// Externally defined in assembly
extern void idt_load();
extern void keyboard_handler();

#endif // _IDT_H
