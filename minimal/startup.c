#include <stdint.h>

void main (void);

void Reset_Handler(void);

// variable defined in linker script
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;
extern uint32_t _etext;
extern uint32_t _estack;

typedef struct _DeviceVectors
{
  /* Stack pointer */
  void* pvStack;

  /* Cortex-M handlers */
  void* pfnReset_Handler;
  void* pfnNMI_Handler;
  void* pfnHardFault_Handler;
} DeviceVectors;


void NMI_Handler(void) {
    while (1) {}
}

void HardFault_Handler(void) {
    while (1) {}
}

/* Exception Table */
__attribute__ ((section(".vectors")))
const DeviceVectors exception_table = {
        /* Configure Initial Stack Pointer, using linker-generated symbols */
        .pvStack                = (void*) (&_estack),
        .pfnReset_Handler       = (void*) Reset_Handler,
        .pfnNMI_Handler         = (void*) NMI_Handler,
        .pfnHardFault_Handler   = (void*) HardFault_Handler,

};

void Reset_Handler(void)
{
    // _sbss, _ebss
    // clear the zero segment
    for(unsigned long * bss_ptr = &_sbss; bss_ptr < &_ebss; bss_ptr++)
    {
        *bss_ptr = 0;
    }

    // copy initialized data from flash to ram
    // (on flash, data locates in .data section, which is at the end of .text)
    // (on RAM, data locates at _sdata)
    uint32_t * init_value_ptr = &_etext;
    for (uint32_t * data_ptr = &_sdata; data_ptr < &_edata; data_ptr++)
    {
        *data_ptr = *init_value_ptr++;
    }

    main();

    while(1);

}