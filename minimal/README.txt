To identify sections in the output file, first, build the source code:
    arm-none-eabi-gcc -c main.c -o build/main.o
then use objdump -h to get sections:
    arm-none-eabi-objdump -h build/main.o

Build elf:
    arm-none-eabi-gcc build/main.o -o build/main.elf --specs=nosys.specs