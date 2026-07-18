#ifndef MY_RTOS
#define MY_RTOS

#include <stdint.h>

typedef struct
{
    volatile uint32_t *stack_pointer;
} TCB_t;

void xTaskCreate(void (*task_func)(void), uint32_t *stack_memory, uint32_t stack_size);


#endif