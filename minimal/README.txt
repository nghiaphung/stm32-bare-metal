To identify sections in the output file, first, build the source code:
    arm-none-eabi-gcc -c main.c -o build/main.o
then use objdump -h to get sections:
    arm-none-eabi-objdump -h build/main.o

Build elf:
    arm-none-eabi-gcc build/main.o -o build/main.elf --specs=nosys.specs

Flash binary
./stlink/bin/st-flash write ~/Project/stm32-bare-metal/minimal/build/minimal.bin

some issue:
"undefined reference to `__aeabi_idiv`" 
"undefined reference to memcpy":
=======> check LDFLAG, CFLAG

In ld file:
    .text section, .vector section always need to be put at the begining of FLASH (0x800 0000).
    The address 0x800 0000 in FLASH is alias to 0x0000 0000 in RAM.
    -> The layout of .vector is:
    ---------------------------
    address of the top of stack
    ---------------------------
    reset handler
    ---------------------------
    nmi handler
    ---------------------------
    hardfault handler  
    ---------------------------

What does Reset_Handler() do?
    The basic and madatory task of Reset_Handler() is:
        clear the .bss section (.bss is the uninitialized variables or zero static variales)
        copy .data section from FLASH to RAM. .data section contains initialized value
        Jump to main
