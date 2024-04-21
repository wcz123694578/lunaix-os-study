#ifndef __LUNAIX_GDT_H
#define __LUNAIX_GDT_H 1

/* SD各个位的值 */
#define SD_TYPE(x)          (x << 8)
#define SD_CODE_DATA(x)     (x << 12)
#define SD_DPL(x)           (x << 13)
#define SD_PRESENT(x)       (x << 15)
#define SD_AVL(x)           (x << 20)
#define SD_64BITS(x)        (x << 21)
#define SD_32BITS(x)        (x << 22)
#define SD_4K_GRAN(x)       (x << 23)

#define SEG_LIM_L(x)        (x & 0x0ffff)
#define SEG_LIM_H(x)        (x & 0xf0000)
#define SEG_BASE_L(x)       ((x & 0x0000ffff) << 16)
#define SEG_BASE_M(x)       ((x & 0x00ff0000) >> 16)
#define SEG_BASE_H(x)       (x & 0xff000000)

#define SEG_DATA_RD         0x00
#define SEG_DATA_RDA        0x01
#define SEG_DATA_RDWR       0x02
#define SEG_DATA_RDWRA      0x03
#define SEG_DATA_RDEXPD     0x04
#define SEG_DATA_RDEXPDA    0x05
#define SEG_DATA_RDWREXPD   0x06
#define SEG_DATA_RDWREXPDA  0x07
#define SEG_CODE_EX         0X08
#define SEG_CODE_EXA        0X09
#define SEG_CODE_EXRD       0X0A
#define SEG_CODE_EXRDA      0X0B
#define SEG_CODE_EXC        0X0C
#define SEG_CODE_EXCA       0X0D
#define SEG_CODE_EXRDC      0X0E
#define SEG_CODE_EXRDCA     0X0F

#define SEG_R0_CODE         SD_TYPE(SEG_CODE_EXRD) | SD_CODE_DATA(1) | SD_DPL(0) |\
                            SD_PRESENT(1) | SD_AVL(0) | SD_64BITS(0) | SD_32BITS(1) |\
                            SD_4K_GRAN(1)

#define SEG_R0_DATA         SD_TYPE(SEG_DATA_RDWR) | SD_CODE_DATA(1) | SD_DPL(0) |\
                            SD_PRESENT(1) | SD_AVL(0) | SD_64BITS(0) | SD_32BITS(1) |\
                            SD_4K_GRAN(1)

#define SEG_R3_CODE         SD_TYPE(SEG_CODE_EXRD) | SD_CODE_DATA(1) | SD_DPL(3) |\
                            SD_PRESENT(1) | SD_AVL(0) | SD_64BITS(0) | SD_32BITS(1) |\
                            SD_4K_GRAN(1)

#define SEG_R3_DATA         SD_TYPE(SEG_DATA_RDWR) | SD_CODE_DATA(1) | SD_DPL(3) |\
                            SD_PRESENT(1) | SD_AVL(0) | SD_64BITS(0) | SD_32BITS(1) |\
                            SD_4K_GRAN(1)

void _init_gdt();
#endif