void kernel_main(void) {
    const char *str = "Hello, Kernel!"; 
    char *vidptr = (char*)0xb8000;  // video memory begins here.
    unsigned int i = 0;
    unsigned int j = 0;

    // clear the screen
    while (j < 80 * 25 * 2) {
        vidptr[j] = ' ';
        vidptr[j + 1] = 0x07;
        j = j + 2;
    }

    // print the string
    j = 0;
    while (str[i] != '\0') {
        vidptr[j] = str[i];
        vidptr[j + 1] = 0x07;
        ++i;
        j = j + 2;
    }
}
