// Custom implementation of strcmp
int strcmp(const char *str1, const char *str2) {
    while (*str1 && (*str1 == *str2)) {
        str1++;
        str2++;
    }
    return *(unsigned char *)str1 - *(unsigned char *)str2;
}

void newline(volatile char *video, int *cursor) {
    *cursor = (*cursor / 160 + 1) * 160;
}

void user_print_debug(const char *msg, int *cursor) {
    volatile char *video = (volatile char*)0xb8000;
    while (*msg) {
        video[*cursor * 2] = *msg++;
        video[*cursor * 2 + 1] = 0x07;
        (*cursor)++;
    }
}

__attribute__((section(".text.user"))) void user_main() {
    volatile char *video = (volatile char*)0xb8000;
    const char *welcome_str = "Hello from user space! Type a command: ";
    int i = 0;

    // Display the welcome message
    while (welcome_str[i] != '\0') {
        video[i*2] = welcome_str[i];
        video[i*2 + 1] = 0x07;
        i++;
    }

    int cursor = i;
    char buffer[80];
    int buffer_index = 0;

    user_print_debug("User: Started main loop\n", &cursor);

    while (1) {
        char key = *(volatile char*)0x00120000;
        if (key != 0) { // Check for a keypress
            *(volatile char*)0x00120000 = 0; // Clear the key
            user_print_debug("User: Key detected\n", &cursor);

            if (key == '\n' || key == '\r') { // Enter key
                buffer[buffer_index] = '\0'; // Null-terminate the command

                // Process command
                if (strcmp(buffer, "clear") == 0) {
                    // Clear screen command
                    for (int j = 0; j < 80 * 25; j++) {
                        video[j*2] = ' ';
                        video[j*2 + 1] = 0x07;
                    }
                    cursor = 0;
                    user_print_debug("User: Screen cleared\n", &cursor);
                } else if (strcmp(buffer, "hello") == 0) {
                    const char *response = "Hello, user!\n";
                    int j = 0;
                    while (response[j] != '\0') {
                        video[cursor*2] = response[j];
                        video[cursor*2 + 1] = 0x07;
                        cursor++;
                        if (cursor >= 80 * 25 * 2) {
                            newline(video, &cursor);
                        }
                        j++;
                    }
                    user_print_debug("User: Command 'hello' executed\n", &cursor);
                } else {
                    // Unknown command
                    const char *error_str = "Unknown command\n";
                    int j = 0;
                    while (error_str[j] != '\0') {
                        video[cursor*2] = error_str[j];
                        video[cursor*2 + 1] = 0x07;
                        cursor++;
                        if (cursor >= 80 * 25 * 2) {
                            newline(video, &cursor);
                        }
                        j++;
                    }
                    user_print_debug("User: Unknown command\n", &cursor);
                }

                // Reset the buffer
                buffer_index = 0;
                const char *prompt_str = "Type a command: ";
                i = 0;
                while (prompt_str[i] != '\0') {
                    video[cursor*2] = prompt_str[i];
                    video[cursor*2 + 1] = 0x07;
                    cursor++;
                    if (cursor >= 80 * 25 * 2) {
                        newline(video, &cursor);
                    }
                    i++;
                }
            } else if (key == '\b') { // Backspace key
                if (buffer_index > 0) {
                    buffer_index--;
                    cursor--;
                    video[cursor*2] = ' ';
                }
            } else {
                // Add character to buffer and display it
                buffer[buffer_index++] = key;
                video[cursor*2] = key;
                video[cursor*2 + 1] = 0x07;
                cursor++;
                if (cursor >= 80 * 25 * 2) {
                    newline(video, &cursor);
                }
            }
        }
    }
}
