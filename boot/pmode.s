BITS 32

section .text
global protected_mode
extern kernel_main

protected_mode:
    ; Set up data segments
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    ; Jump to the kernel entry point
    call kernel_main

.hang:
    jmp .hang
