#include "my_rtos.h"
#include "my_rtos_headers.h"

#define MAX_TASKS 3
#define MAX_PRIORITY 5

#define STACK_SIZE_IDLE 32

TCB_t *current_tcb = 0;
static TCB_t task_list[MAX_TASKS + 1];
static uint32_t task_count = 0;
static uint32_t current_task_index = 0;

volatile uint32_t system_ticks = 0;

static uint32_t idle_stack[STACK_SIZE_IDLE];

static void task_exit(void)
{
    while(1)
    {

    }
}

void xTaskCreate(void (*task_func)(void), uint32_t *stack_memory, uint32_t stack_size, uint32_t priority)
{
    if(task_count >= (MAX_TASKS + 1))
    {
        return;
    }

    if(priority > MAX_PRIORITY + 1)
    {
        return;
    }

    uint32_t *top_of_stack = &stack_memory[stack_size];

    top_of_stack -= 16;

    // Populate Auto-Popped Registers (by Hardware)
    top_of_stack[15] = 0x01000000;          // Set xPSR to Thumb Mode
    top_of_stack[14] = (uint32_t)task_func; // PC value
    top_of_stack[13] = (uint32_t)task_exit; // LR value if task returns
    top_of_stack[12] = 0x12121212;          // R12
    top_of_stack[11] = 0x03030303;          // R3
    top_of_stack[10] = 0x02020202;          // R2
    top_of_stack[9] = 0x01010101;           // R1
    top_of_stack[8] = 0x00000000;           // R0

    // Populate Manually-Popped Registers (by software)
    top_of_stack[7] = 0x07070707;           // R7
    top_of_stack[6] = 0x06060606;           // R6
    top_of_stack[5] = 0x05050505;           // R5
    top_of_stack[4] = 0x04040404;           // R4
    top_of_stack[3] = 0x11111111;           // R11
    top_of_stack[2] = 0x10101010;           // R10
    top_of_stack[1] = 0x09090909;           // R9
    top_of_stack[0] = 0x08080808;           // R8


    task_list[task_count].stack_pointer = top_of_stack;
    task_list[task_count].priority = priority;
    task_list[task_count].state = READY;
    task_list[task_count].delay_ticks = 0;

    if(task_count == 0)
    {
        current_tcb = &task_list[0];
    }

    task_count++;
}

void vTaskDelay(uint32_t wait_time)
{
    if(wait_time > 0)
    {
        __asm volatile ("cpsid i");

        current_tcb->state = BLOCKED;
        current_tcb->delay_ticks = wait_time;
        ICSR = (1 << 28);

        __asm volatile ("cpsie i");
    }
}

void os_scheduler_yield(void)
{
    uint32_t task_iterator = current_task_index;
    uint32_t next_task_index = current_task_index;
    uint32_t best_priority = MAX_PRIORITY + 2;

    for(int i = 0; i < task_count; i++)
    {
        task_iterator = (task_iterator + 1) % task_count;

        if(task_list[task_iterator].state != READY)
        {
            continue;
        }

        if(task_list[task_iterator].priority < best_priority)
        {
            best_priority = task_list[task_iterator].priority;
            next_task_index = task_iterator;
        }
    }

    current_task_index = next_task_index;
    current_tcb = &task_list[current_task_index];
}

void decrement_task_ticks()
{
    for(int i = 0; i < task_count; i++)
    {
        if(task_list[i].state == BLOCKED)
        {
            if((--task_list[i].delay_ticks) == 0)
                task_list[i].state = READY;
        }
    }
}

void idle_task(void)
{
    while(1);
}

void create_idle_task(void)
{
    xTaskCreate(idle_task, idle_stack, STACK_SIZE_IDLE, MAX_PRIORITY + 1);
}
