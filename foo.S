//Systick Configuration Registers
.equ SYST_CSR, 0xE000E010
.equ SYST_RVR, 0xE000E014
.equ SYST_CVR, 0xE000E018
.equ SYST_CALIB, 0xE000E01C

.equ ICSR, 0xE000ED04
.equ SHPR3, 0xE000ED20

.equ TIMEOUT, 0x00FFFFFF

.equ FUNCTION_POS, 0x20002000

.section .vectors
vector_table:
    //Starting Address of SRAM in this CPU is 0x20000000
    //We are going 4KB above that starting address for the base of the stack pointer
    //Stack Pointer grows downwards
    // .word 0x20001000
    //Earlier defined memory location was beyond stack memory defined in linker script
    .word _estack
    .word reset_handler

//PendSV handler to be added at vector table address 0x38
//Systick handler to be added at vector table address 0x3C, so it can be defined just after pendSV_handler
.org 0x38
    .word pendSV_handler
    .word systick_handler
    .zero 400

.section .text

.extern current_tcb
.extern os_scheduler_yield
.extern main

    .align 1 //Used to align instructions to (2^1) = 2 byte boundary since these are 16-bit instructions
    .type reset_handler %function
reset_handler:
    bl main
    bl .

    .section .text
    .align 1
    .global os_start
    .type os_start, %function
os_start:
    ldr r0, =SYST_CSR
    ldr r1, =SYST_RVR
    ldr r2, =SYST_CVR
    ldr r3, =TIMEOUT

    ldr r4, =SHPR3
    ldr r6, =0x00FF0000
    str r6, [r4]

    str r3, [r1]

    mov r3, #0x0
    str r3, [r2]

    mov r3, #0x7
    str r3, [r0]

    bx lr

    .section .text
    .align 1
    .type systick_handler, %function
systick_handler:
    //Raise PendSV interrupt in ICSR register
    ldr r4, =ICSR
    ldr r5, =(1 << 28)
    str r5, [r4]

    bx lr

.section .text
    .align 1
    .type pendSV_handler, %function
//PendSV interrupt handler
pendSV_handler:
    ldr r4, =first_run
    ldr r5, [r4]
    cmp r5, #1
    beq load_new_sp


    push {r4-r7}
    //The PUSH operation only supports registers upto R7
    mov r0, r8
    mov r1, r9
    mov r2, r10
    mov r3, r11
    push {r0-r3}


    ldr r4, =current_tcb
    ldr r5, [r4]
    mov r0, sp
    str r0, [r5]

    push {lr}
    bl os_scheduler_yield
    pop {r0}
    mov lr, r0

load_new_sp:
    //Clear the first_run flag
    mov r5, #0
    ldr r4, =first_run
    str r5, [r4]

    ldr r4, =current_tcb
    ldr r5, [r4]
    ldr r0, [r5]
    mov sp, r0

    pop {r0-r3}
    mov r8, r0
    mov r9, r1
    mov r10, r2
    mov r11, r3

    pop {r4-r7}

    bx lr

// //Tasks
//     .section .text
//     .p2align    4
//     .global main1
//     .type main1, %function
// main1:
//     NOP
//     add r0, r0, #1
//     b main1

//     .section .text
//     .p2align    4
//     .global main2
//     .type main2, %function
// main2:
//     NOP
//     add r1, r1, #2
//     b main2

//     .section .text
//     .p2align    4
//     .global main3
//     .type main3, %function
// main3:
//     NOP
//     add r2, r2, #4
//     b main3

    .data
    .align 4
    .type first_run, %object
first_run: .word 1