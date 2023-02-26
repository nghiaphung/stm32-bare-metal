CC=arm-none-eabi-gcc
LD=arm-none-eabi-ld
OCPY=arm-none-eabi-objcopy
ODUMP=arm-none-eabi-objdump
SZ=arm-none-eabi-size
OCD=arduino-openocd
MKDIR=mkdir

LDFLAGS += \
	-mcpu=cortex-m0 \
	--specs=nosys.specs \
	-static --specs=nano.specs -mfloat-abi=soft -mthumb -Wl,--start-group -lc -lm -Wl,--end-group \
	-Wl,--gc-sections \
	-Wl,--print-memory-usage \
	-Wl,-Map=$(BUILD_DIR)/$(PROJECT).map \
	-lgcc \
	-T stm32f030r8_flash.ld

 

CFLAGS += \
	-mcpu=cortex-m0 \
	-mthumb \
	-Wall \
	-Werror \
	-std=c11 \
	-O0 \
	-fdebug-prefix-map=$(REPO_ROOT)= \
	-g3 \
	-c \
	-ffreestanding \
	-ffunction-sections \
	-Wl,-gc-sections \
	-fdata-sections \
	-fstack-usage \
	-specs=nano.specs \
	-mfloat-abi=soft \
	-nostdlib \
	-D$(TARGET)

SRCS += \
	$(HAL_DIR)/Src/stm32f0xx_hal.c \
	$(CMSIS_DIR)/Device/ST/STM32F0xx/Source/Templates/system_stm32f0xx.c \
	$(HAL_DIR)/Src/stm32f0xx_hal_cortex.c \
	$(HAL_DIR)/Src/stm32f0xx_hal_gpio.c \
	$(HAL_DIR)/Src/stm32f0xx_hal_rcc.c

INCLUDES += \
	$(HAL_DIR)/Inc \
	$(CMSIS_DIR)/Device/ST/STM32F0xx/Include/ \
	$(CMSIS_DIR)/Include/

CFLAGS += $(foreach i,$(INCLUDES),-I$(i))
CFLAGS += $(foreach d,$(DEFINES),-D$(d))

OBJ_DIR = $(BUILD_DIR)/objs/
OBJS = $(patsubst %.c,$(OBJ_DIR)/%.o,$(SRCS))


.PHONY: all
all: $(BUILD_DIR)/$(PROJECT).bin

$(BUILD_DIR):
	@echo "Create build dir"
	$(NO_ECHO)$(MKDIR) -p $(BUILD_DIR)

$(OBJ_DIR):
	$(NO_ECHO)$(MKDIR) -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: %.c $(OBJ_DIR)
	@echo "Compiling $<"
	$(NO_ECHO)$(MKDIR) -p $(dir $@)
	$(NO_ECHO)$(CC) -c -o $@ $< $(CFLAGS)

$(BUILD_DIR)/$(PROJECT).bin: $(BUILD_DIR)/$(PROJECT).elf $(BUILD_DIR)/$(PROJECT).lst
	$(OCPY) $< $@ -O binary
	$(SZ) $<


$(BUILD_DIR)/$(PROJECT).lst: $(BUILD_DIR)/$(PROJECT).elf $(BUILD_DIR)
	$(ODUMP) -D $< > $@

$(BUILD_DIR)/$(PROJECT).elf: $(OBJS)
	@echo "Linking $@"
	$(NO_ECHO)$(CC) $^ $(LDFLAGS) -o $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)