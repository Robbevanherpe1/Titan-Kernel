__attribute__((section(".text.user"))) void user_main() {
    volatile char *video = (volatile char*)0xb8000;
    const char *str = "Hello from user space!";
    int i = 0;
    while (str[i] != '\0') {
        video[i*2] = str[i];
        video[i*2 + 1] = 0x07;
        i++;
    }
    while(1);
}
