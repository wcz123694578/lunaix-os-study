#include "multiboot.h"

.section .multiboot
    .long MB_MAGIC
    .long MB_ALIGNED_4K_MEM_MAP
    .long CHECKSUM(MB_ALIGNED_4K_MEM_MAP)

.section .bss               // block starting symbol
    // 根据System V的ABI（程序二进制接口规范）规范，栈段必须16位对齐
    .align 16
    // x86栈地址由高地址向低地址增长
    stack_bottom:
        .skip 16318, 0
    stack_top:

.section .text
    .global start_
    start_:
        movl $stack_top, %esp
        // TODO: kernel init
        //   1. Load GTD
        //   2. Load IDT
        //   3. Enable paging
        call _kernel_init

        pushl %ebx
        call _kernel_main
        // kernel返回表示系统退出了，CPU会默认执行到内存的尽头（很危险）

        cli
    j_:
        hlt
        jmp j_
    