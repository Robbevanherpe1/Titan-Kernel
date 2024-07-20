ENTRY(_start)

SECTIONS
{
    . = 0x00100000;

    .text ALIGN(4) :
    {
        *(.multiboot)
        *(.text)
    }

    .rodata ALIGN(4) :
    {
        *(.rodata)
    }

    .data ALIGN(4) :
    {
        *(.data)
    }

    .bss ALIGN(4) :
    {
        *(COMMON)
        *(.bss)
    }

    /* Place the user-space application */
    . = 0x00110000;

    .user_app ALIGN(4) :
    {
        *(.text.user)
    }
}
