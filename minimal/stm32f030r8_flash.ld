MEMORY
{
    FLASH     (rx)     : ORIGIN = 0x08000000,     LENGTH = 64K
    RAM       (xrw)    : ORIGIN = 0x20000000,     LENGTH = 8K
}

STACK_SIZE = 0x2000;

SECTIONS
{
    .text :
    {
        /* Explaination about KEEP:
         here's a --gc-sections option that enables garbage collection of unused input sections.
         The default behavior (of not performing this garbage collection)
         can be restored by specifying --no-gc-sections on the command line.
         When link-time garbage collection is in use (--gc-sections),
         marking sections that should not be eliminated is often useful.
         This is accomplished by surrounding an input section’s wildcard entry with KEEP(),
         as in KEEP(*(.init)) or KEEP(SORT_BY_NAME(*)(.ctors)).
         */
        KEEP(*(.vector*))
        /* Put all function from all files into .text */
        *(.text*)
        _etext = .;
    } > FLASH
    /* data is initialized variable, copy from flash to ram */
    .data :
    {
        _sdata = .;    /* create a global symbol at data start */
        *(.data*)
        _edata = .;     /* create a global symbol at data end */
    } > RAM AT>FLASH

    .bss :
    {
        _sbss = .;    /* create a global symbol at bss start */
        *(.bss*)
        _ebss = .;     /* create a global symbol at bss end */
    } > RAM

    /* .comment section
        run "readelf --string-dump .comment" to get info, as below:
        String dump of section '.comment':
        [     0]  GCC: (15:9-2019-q4-0ubuntu1) 9.2.1 20191025 (release) [ARM/arm-9-branch revision 277599]
        [    59]  GCC: (15:8-2019-q3-1) 8.3.1 20190703 (release) [gcc-8-branch revision 273027]
     */
    .comment :
    {
        *(.comment*)
    } > FLASH

    .ARM.attributes :
    {
        *(.ARM.attributes*)
    } > FLASH

    .stack :
    {
        . = ALIGN(8);
        _sstack = .;
        . = . + STACK_SIZE;
        . = ALIGN(8);
        _estack = .;
    } > RAM
}