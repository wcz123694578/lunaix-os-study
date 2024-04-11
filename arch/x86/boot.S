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
    .type start_, @function

    start_:
        movl $stack_top, %esp
        // TODO: kernel init
        //   1. Load GTD
        //   2. Load IDT
        //   3. Enable paging
        call _kernel_init

        /* 加载gdtr */
        subl $0x6, %esp     // 移动栈顶的指针，腾出6个bytes的空间
        
        movl $_gdt, 2(%esp) 
        movw _gdt_limit, %ax
        movw %ax, (%esp)
        lgdt (%esp)
        /* 加载idtr */
        movl $_idt, 2(%esp) 
        movw _idt_limit, %ax
        movw %ax, (%esp)
        lidt (%esp)

        addl $0x6, %esp

        /* 初始化段寄存器 */
        movw $0x10, %cx
        movw %cx, %es
        movw %cx, %ds
        movw %cx, %fs
        movw %cx, %gs
        movw %cx, %ss

        /* 更新cs, ip */
        pushw $0x08
        pushl $_after_gdt
        retf
        
    _after_gdt:
        pushl %ebx
        call _kernel_main
        // kernel返回表示系统退出了，CPU会默认执行到内存的尽头（很危险）

        cli
    j_:
        hlt
        jmp j_
    