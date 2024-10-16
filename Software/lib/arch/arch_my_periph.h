#ifndef ARCH_MY_PERIPH_H
#define ARCH_MY_PERIPH_H

#include "arch.h"

// Define the structure representing the E1 register
typedef struct {
    volatile unsigned int REG1;
    volatile unsigned int REG2;
    volatile unsigned int REG3;
    volatile unsigned int REG4;

} MY_PERIPH_t;

#endif 