#include "my_rtos.h"

#define STACK_SIZE_WORDS 64

static uint32_t stack1[STACK_SIZE_WORDS];
static uint32_t stack2[STACK_SIZE_WORDS];

extern void os_start(void);

void main1(void)
{
    static int a = 0;
    static int b = 0;


    while(1)
    {
        a++;
        b += 2;
    }
}

void main2(void)
{
    static int a = 0;
    static int b = 0;

    while(1)
    {
        a += 2;
        b += 4;
    }
}


void main()
{
    xTaskCreate(main1, stack1, STACK_SIZE_WORDS);
    xTaskCreate(main2, stack2, STACK_SIZE_WORDS);

    os_start();

    while(1);
}