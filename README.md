```
The code provided as part of this repository is ONLY for learning purposes!
```

# Resources

Refer to the following resource when progressing through the course:
1. [Cortex-M for Beginners - 2017_EN_v2.pdf](https://community.arm.com/cfs-file/__key/telligent-evolution-components-attachments/01-2057-00-00-00-01-28-35/Cortex_2D00_M-for-Beginners-_2D00_-2017_5F00_EN_5F00_v2.pdf)
2. [Arm_Cortex-M_Processor_Comparison_Table.pdf](https://documentation-service.arm.com/static/655e085f2c8b3557fee7048f?token=)
3. [ARM Architecture Reference Manual Thumb-2 Supplement](https://documentation-service.arm.com/static/661d03b55d66282bc2cf7868?token=)

## Documentation
1. [gnu as](https://ftp.gnu.org/old-gnu/Manuals/gas/html_chapter/as_toc.html)
1. [Cortex-M3 Instructions](https://developer.arm.com/documentation/ddi0337/h/programmers-model/instruction-set-summary/cortex-m3-instructions)

### STM32VL Discovery
1. [STM32F100x reference manual](https://www.st.com/resource/en/reference_manual/cd00246267-stm32f100xx-advanced-arm-based-32-bit-mcus-stmicroelectronics.pdf)
1. [STM32F100x data sheet](https://www.st.com/resource/en/datasheet/stm32f100cb.pdf)

### Cortex-M3 Documentation
1. [Cortex-M3 Devices Generic User Guide](https://developer.arm.com/documentation/dui0552/latest/)

### Issues Faced
1. `.balign 8` is needed before defining stack because before popping, stack pointer has to be at an 8-byte boundary, otherwise it will miss instructions.
2. `.type` directive is necessary before writing any functions so that the processor knows that we are executing in thumb mode and not ARM mode. Cortex-M supports only thumb mode, and the address bit 0 is set to signify thumb mode of operation. The .type directive takes care of that.

### Future Upgrades
1. Use a linked list to insert new tasks, and keep IDLE task by default at the end of the list.
2. Maintain two lists, one READY list and one DELAYED list for faster traversal through the lists.
3. Keep the task with shortest wait time at the top of the list, and then compare with just that to minimize list traversal.

# Copyright
Copyright © 2025 pyjamabrah.com. All Rights Reserved.
