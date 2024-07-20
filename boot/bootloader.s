BITS 32

section .multiboot
align 4
header:
    dd 0x1BADB002   ; magic number
    dd 0x0          ; flags
    dd -(0x1BADB002) ; checksum

section .text
global _start
extern protected_mode

_start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Enter protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Far jump to flush the prefetch queue and set up CS
    jmp 08h:protected_mode

section .gdt
align 8
gdt_start:
    dq 0

    ; Code segment descriptor
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

    ; Data segment descriptor
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

section .padding
    times 510-($-$$) db 0
    dw 0xaa55
