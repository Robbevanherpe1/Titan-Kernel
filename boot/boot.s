BITS 32
[org 0x7c00]

mov ax, 0x10
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax
mov esp, 0x9fc00

call start_kernel

cli
hlt

start_kernel:
    mov ebx, kernel_stack
    mov esp, ebx
    extern kernel_main
    call kernel_main
.hang:
    jmp .hang

kernel_stack:
    times 512 db 0

times 510-($-$$) db 0
dw 0xaa55
