#ifndef ARCH_VGA_H
#define ARCH_VGA_H

#include "arch.h"

// Define the structure representing the E1 register
typedef struct {
    volatile unsigned int Background;
    volatile unsigned int X1_Position;
    volatile unsigned int Y1_Position;
    volatile unsigned int X2_Position;
    volatile unsigned int Y2_Position;
    volatile unsigned int X3_Position;
    volatile unsigned int Y3_Position;
    volatile unsigned int X4_Position;
    volatile unsigned int Y4_Position;
    volatile unsigned int X5_Position;
    volatile unsigned int Y5_Position;

} MY_VGA_t;

#endif /* ARCH_VGA_H */