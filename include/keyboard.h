#ifndef _KEYBOARD_H
#define _KEYBOARD_H

#include <stdint.h>

// Function prototypes
char scancode_to_char(uint8_t scancode);
void keyboard_handler_main();

// Last key pressed
extern volatile char last_key;

#endif // _KEYBOARD_H
