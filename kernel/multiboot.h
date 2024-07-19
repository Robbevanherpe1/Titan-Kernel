#ifndef MULTIBOOT_H
#define MULTIBOOT_H

#include "stdint.h"

#define MULTIBOOT_HEADER_MAGIC 0x1BADB002
#define MULTIBOOT_HEADER_FLAGS 0x00000003

typedef struct multiboot_header {
    uint32_t magic;
    uint32_t flags;
    uint32_t checksum;
} __attribute__((packed)) multiboot_header_t;

#endif /* MULTIBOOT_H */
