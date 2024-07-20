__attribute__((section(".text.user"))) void user_main() {
    volatile char *video = (volatile char*)0xb8000;
    const char *str = "Hello from user space!";
    int i = 0;
    while (str[i] != '\0') {
        video[i*2] = str[i];
        video[i*2 + 1] = 0x07;
        i++;
    }
     int cursor = i;
    while(1) {
        if (*(volatile char*)0x00120000 != 0) { // assuming the kernel updates this address with the latest key
            char key = *(volatile char*)0x00120000;
            video[cursor*2] = key;
            video[cursor*2 + 1] = 0x07;
            cursor++;
            *(volatile char*)0x00120000 = 0; // clear the key
        }
    }
}
