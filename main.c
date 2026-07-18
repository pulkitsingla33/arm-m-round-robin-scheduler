#include "my_rtos.h"

#define STACK_SIZE_WORDS 64

static uint32_t stack1[STACK_SIZE_WORDS];
static uint32_t stack2[STACK_SIZE_WORDS];

void main()
{
    xTaskCreate(main1, stack1, STACK_SIZE_WORDS);
    xTaskCreate(main2, stack2, STACK_SIZE_WORDS);

    while(1);
}