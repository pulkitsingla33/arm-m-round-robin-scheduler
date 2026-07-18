#include "my_rtos.h"

#define STACK_SIZE_WORDS 64

static uint32_t stack1[STACK_SIZE_WORDS];
static uint32_t stack2[STACK_SIZE_WORDS];

extern void os_start(void);

void main1(void)
{
    int a = 0;
    int b = 0;
    while(1)
    {
        a++;
        b += 2;
    }
}

void main2(void)
{
    int a = 0;
    int b = 0;
    while(1)
    {
        a += 2;
        b += 4;
    }
}

void main()
{
    xTaskCreate(main1, stack1, STACK_SIZE_WORDS, 0);
    xTaskCreate(main2, stack2, STACK_SIZE_WORDS, 0);

    os_start();

    while(1);
}