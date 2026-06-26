.section .vectors
vector_table:
    //Starting Address of SRAM in this CPU is 0x20000000
    //We are going 4KB above that starting address for the base of the stack pointer
    //Stack Pointer grows downwards
    .word 0x20001000
    .word reset_handler
    .zero 400

.section .text
    .align 1 //Used to align instructions to (2^1) = 2 byte boundary since these are 16-bit instructions
    .type reset_handler %function
reset_handler:
    mov r1, #7
    mov r2, #3

    push {r1, r2}

    mov r1, #5
    mov r2, #6

    pop {r2, r1}
    bl .