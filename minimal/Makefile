PROJECT := minimal
BUILD_DIR ?= build
CFLAGS += -nostdlib

SRCS = \
	startup.c \
	$(PROJECT).c

CC=arm-none-eabi-gcc
LD=arm-none-eabi-ld
OCPY=arm-none-eabi-objcopy
ODUMP=arm-none-eabi-objdump
SZ=arm-none-eabi-size
OCD=arduino-openocd
MKDIR=mkdir

LDFLAGS += \
	-specs=nano.specs \
	-Wl,--gc-sections \
	-Wl,--print-memory-usage \
	-Wl,-Map=$(BUILD_DIR)/$(PROJECT).map \
	-T stm32f030r8_flash.ld

CFLAGS += \
	-mcpu=cortex-m0 \
	-mthumb \
	-Wall \
	-Werror \
	-std=c11 \
	-O0 \
	-fdebug-prefix-map=$(REPO_ROOT)= \
	-g \
	-ffreestanding \
	-ffunction-sections \
	-fdata-sections

CFLAGS += $(foreach i,$(INCLUDES),-I$(i))
CFLAGS += $(foreach d,$(DEFINES),-D$(d))

OBJS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRCS))


.PHONY: all
all: $(BUILD_DIR)/$(PROJECT).bin

$(BUILD_DIR):
	@echo "Create build dir"
	$(NO_ECHO)$(MKDIR) -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: %.c $(BUILD_DIR)
	@echo "Compiling $<"
	$(NO_ECHO)$(CC) -c -o $@ $< $(CFLAGS)

$(BUILD_DIR)/$(PROJECT).bin: $(BUILD_DIR)/$(PROJECT).elf $(BUILD_DIR)/$(PROJECT).lst
	$(OCPY) $< $@ -O binary
	$(SZ) $<


$(BUILD_DIR)/$(PROJECT).lst: $(BUILD_DIR)/$(PROJECT).elf $(BUILD_DIR)
	$(ODUMP) -D $< > $@

$(BUILD_DIR)/$(PROJECT).elf: $(OBJS)
	@echo "Linking $@"
	$(NO_ECHO)$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)