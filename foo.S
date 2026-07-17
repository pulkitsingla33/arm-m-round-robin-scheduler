//Systick Configuration Registers
.equ SYST_CSR, 0xE000E010
.equ SYST_RVR, 0xE000E014
.equ SYST_CVR, 0xE000E018
.equ SYST_CALIB, 0xE000E01C

.equ ICSR, 0xE000ED04

.equ TIMEOUT, 0x00FFFFFF

.equ FUNCTION_POS, 0x20002000

.section .vectors
vector_table:
    //Starting Address of SRAM in this CPU is 0x20000000
    //We are going 4KB above that starting address for the base of the stack pointer
    //Stack Pointer grows downwards
    .word 0x20001000
    .word reset_handler

//PendSV handler to be added at vector table address 0x38
//Systick handler to be added at vector table address 0x3C, so it can be defined just after pendSV_handler
.org 0x38
    .word pendSV_handler
    .word systick_handler
    .zero 400

.section .text
    .align 1 //Used to align instructions to (2^1) = 2 byte boundary since these are 16-bit instructions
    .type reset_handler %function
reset_handler:
    mov r5, #0

    ldr r0, =SYST_CSR
    ldr r1, =SYST_RVR
    ldr r2, =SYST_CVR
    ldr r3, =TIMEOUT



    str r3, [r1]

    mov r3, #0x0
    str r3, [r2]

    mov r3, #0x7
    str r3, [r0]

    bl .

    .section .text
    .align 1
    .type systick_handler, %function
systick_handler:
    // push {r4-r7}

    // //The PUSH operation only supports registers upto R7
    // mov r0, r8
    // mov r1, r9
    // mov r2, r10
    // mov r3, r11
    // push {r0-r3}

    ldr r4, =ICSR
    ldr r5, =(1 << 28)
    str r5, [r4]

// breakpoint_pos:

//     ldr r4, =first_run
//     ldr r5, [r4]
//     cmp r5, #1
//     beq skip_save

//     ldr r4, =current_task
//     ldr r5, [r4]
//     ldr r6, =sp_array
//     mov r7, r5
//     lsl r7, r7, #2
//     add r7, r7, r6
//     mov r0, sp
//     str r0, [r7]

//     add r5, r5, #1
//     cmp r5, #3
//     bne save_index
//     mov r5, #0
// save_index:
//     str r5, [r4]
//     b load_new_sp

// skip_save:
//     mov r5, #0
//     str r5, [r4]
//     ldr r4, =current_task
//     str r5, [r4]

// load_new_sp:
//     ldr r6, =sp_array
//     mov r7, r5
//     lsl r7, r7, #2
//     add r7, r7, r6
//     ldr r0, [r7]
//     mov sp, r0

//     pop {r0-r3}

//     mov r8, r0
//     mov r9, r1
//     mov r10, r2
//     mov r11, r3

//     pop {r4-r7}

//     bx lr



pendSV_handler:
    ldr r0, =ICSR
    ldr r1, =(1 << 27)
    str r1, [r0]

    push {r4-r7}

    //The PUSH operation only supports registers upto R7
    mov r0, r8
    mov r1, r9
    mov r2, r10
    mov r3, r11
    push {r0-r3}

    ldr r4, =first_run
    ldr r5, [r4]
    cmp r5, #1
    beq skip_save

    ldr r4, =current_task
    ldr r5, [r4]
    ldr r6, =sp_array
    mov r7, r5
    lsl r7, r7, #2
    add r7, r7, r6
    mov r0, sp
    str r0, [r7]

    add r5, r5, #1
    cmp r5, #3
    bne save_index
    mov r5, #0
save_index:
    str r5, [r4]
    b load_new_sp

skip_save:
    mov r5, #0
    str r5, [r4]
    ldr r4, =current_task
    str r5, [r4]

load_new_sp:
    ldr r6, =sp_array
    mov r7, r5
    lsl r7, r7, #2
    add r7, r7, r6
    ldr r0, [r7]
    mov sp, r0

    pop {r0-r3}

    mov r8, r0
    mov r9, r1
    mov r10, r2
    mov r11, r3

    pop {r4-r7}

    bx lr

//Tasks
    .section .text
    .p2align    4
    .global main1
    .type main1, %function
main1:
    NOP
    add r0, r0, #1
    b main1

    .section .text
    .p2align    4
    .global main2
    .type main2, %function
main2:
    NOP
    add r1, r1, #2
    b main2

    .section .text
    .p2align    4
    .global main3
    .type main3, %function
main3:
    NOP
    add r2, r2, #4
    b main3

    .data
    .align 4

current_task:   .word 0
first_run:      .word 1

sp_array:
    .word stack1
    .word stack2
    .word stack3
// These are the three stack regions defined for each task.
// When we want to run the function, we pop these stacks, and at the end of the stack the PC changes to the actual function.

.balign    8
stack1:
    .word 0x18
    .word 0x19
    .word 0x1a
    .word 0x1b
    .word 0x14
    .word 0x15
    .word 0x16
    .word 0x17
    .word 0x10
    .word 0x11
    .word 0x12
    .word 0x13
    .word 0x1C
    .word 0x309
    .word main1
    .word 0x1000000
    .zero 64

    .balign 8
stack2:
    .word 0x28
    .word 0x29
    .word 0x2a
    .word 0x2b
    .word 0x24
    .word 0x25
    .word 0x26
    .word 0x27
    .word 0x20
    .word 0x21
    .word 0x22
    .word 0x23
    .word 0x2C
    .word 0x309
    .word main2
    .word 0x1000000
    .zero 64

    .balign 8
stack3:
    .word 0x38
    .word 0x39
    .word 0x3a
    .word 0x3b
    .word 0x34
    .word 0x35
    .word 0x36
    .word 0x37
    .word 0x30
    .word 0x31
    .word 0x32
    .word 0x33
    .word 0x3C
    .word 0x309
    .word main3
    .word 0x1000000
    .zero 64
    .align 4