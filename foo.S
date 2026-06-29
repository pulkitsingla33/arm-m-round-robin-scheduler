//Systick Configuration Registers
.equ SYST_CSR, 0xE000E010
.equ SYST_RVR, 0xE000E014
.equ SYST_CVR, 0xE000E018
.equ SYST_CALIB, 0xE000E01C
.equ TIMEOUT, 0x00FFFFFF

.section .vectors
vector_table:
    //Starting Address of SRAM in this CPU is 0x20000000
    //We are going 4KB above that starting address for the base of the stack pointer
    //Stack Pointer grows downwards
    .word 0x20001000
    .word reset_handler

.org 0x3C
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
    push {r4-r7}

    //The PUSH operation only supports registers upto R7
    mov r0, r8
    mov r1, r9
    mov r2, r10
    mov r3, r11
    push {r0-r3}
breakpoint_pos:

    pop {r0-r3}

    mov r8, r0
    mov r9, r1
    mov r10, r2
    mov r11, r3

    pop {r4-r7}

    bx lr