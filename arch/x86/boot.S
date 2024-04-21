#define __ASM__ 1
#include <arch/x86/boot/multiboot.h>

#define MB_FLAGS    MULTIBOOT_MEMORY_INFO | MULTIBOOT_PAGE_ALIGN
#define KPG_SIZE    24*1024

.section .multiboot
    .long MULTIBOOT_MAGIC
    .long MB_FLAGS
    .long CHECKSUM(MB_FLAGS)

.section .bss               /* block starting symbol */
    .global	mb_info
    /* 根据System V的ABI（程序二进制接口规范）规范，栈段必须16位对齐 */
    .align 16
    /* x86栈地址由高地址向低地址增长 */
    mb_info:
        .skip 4096
    stack_bottom:
        .skip 16318, 0
    stack_top:

.section .kpg
    .global _k_ptd
    _k_ptd:
        .skip KPG_SIZE, 0

.section .hhk_init
    .global start_
    .type start_, @function

    start_:
        movl $stack_top, %esp
        
        subl $16, %esp
        
        /**
         * 将multiboot_info移到预留的空间里，
         * 而后在_hhk_init里对所有高半核初始化代码进行Identity map
         * 保证当分页与虚拟地址开启后内核能够访问到multiboot info table
         */
        
        movl $mb_info, 4(%esp)
        movl %ebx, (%esp)
        call _save_multiboot_info

        /**
         * _hhk_init：
         * 1. 设置GDT
         * 2. 设置IDT
         * 3. 初始化最简单的PTD与PT
         */

        movl $(KPG_SIZE), 4(%esp)
        movl $(_k_ptd - 0xC0000000), (%esp)
        call _hhk_init

        /*
            基本的映射定义好了就可以打开分页了。
            只需将PTD基地址放进CR3
        */

        /* 加载PTD基地址(物理地址) */
        movl (%esp), %eax
        andl $0xfffff000, %eax
        movl %eax, %cr3

        /* 开启分页与地址转换(CR0, PG=1) */
        movl %cr0, %eax
        orl $0x80000000, %eax
        movl %eax, %cr0

        addl $16, %esp

        /* 进入高半核 */
        pushl $hhk_entry_
        ret