#ifndef MY_RTOS
#define MY_RTOS

#include <stdint.h>

enum TASK_STATES {READY, BLOCKED, SUSPENDED};

typedef struct
{
    volatile uint32_t *stack_pointer;
    uint32_t priority;
    uint8_t state;
    uint32_t delay_ticks;
} TCB_t;

void xTaskCreate(void (*task_func)(void), uint32_t *stack_memory, uint32_t stack_size, uint32_t priority);
void vTaskDelay(uint32_t wait_time);


#endif