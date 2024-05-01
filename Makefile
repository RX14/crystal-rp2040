blinky.o: blinky.cr
	crystal build --release --cross-compile --target arm-none-eabi --mcpu cortex-m0plus --prelude empty -o "$@" "$<" > /dev/null

blinky.prechecksum.elf: blinky.o boot/pico-boot-stage2.o
	ld.lld --emit-relocs --gc-sections -T boot/rp2040.ld --defsym=__flash_size=2048K -o "$@" $^

blinky.elf: blinky.prechecksum.elf tools/stage2-checksum
	tools/stage2-checksum "$<" "$@"

boot/pico-boot-stage2.o: boot/pico-boot-stage2.S boot/rp2040-boot-stage2.S
	clang --target=arm-none-eabi -mcpu=cortex-m0plus -c -o "$@" "$<"

tools/stage2-checksum: tools/stage2-checksum.cr
	crystal build -o "$@" "$<"

.PHONY: clean
clean:
	rm -f blinky.o blinky.prechecksum.elf blinky.elf boot/pico-boot-stage2.o

.PHONY: clean-tools
clean-tools:
	rm -f tools/stage2-checksum
