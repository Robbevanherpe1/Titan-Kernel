section .multiboot
align 4
dd 0x1BADB002              ; magic number
dd 0                       ; flags
dd -(0x1BADB002)           ; checksum

section .text
extern kernel_main
global _start

_start:
    cli                    ; Clear interrupts
    call kernel_main       ; Call kernel main
    hlt                    ; Halt the CPU
