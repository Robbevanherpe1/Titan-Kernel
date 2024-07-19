BITS 32
# start address for the kernel
[org 0x7c00]

start:
    # set up the stack pointer
    mov ax, 0x07C0
    add ax, 288
    mov ss, ax
    mov sp, 4096

    # set up the segments
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call start_kernel

    # halt the computer
    cli
    hlt

start_kernel:
    # set up the stack pointer
    mov ebx, kernel_stack
    mov esp, ebx

    # jump to the kernel
    extern kernel_main
    call kernel_main
.hang:
    jmp .hang

# the kernel stack
kernel_stack:
    times 512 db 0

# padding to make the file 512 bytes
times 510-($-$$) db 0
dw 0xaa55
