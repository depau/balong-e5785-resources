# Kernel reverse engineering

This directory contains decompiler projects from Ghidra, IDA Pro and Binary
Ninja for the downstream kernel binary used in the E5785 usbloader firmware.

`Image.elf` is the kernel binary extracted from the stock firmware, converted to
an ELF binary using the amazing [
`vmlinux-to-elf`](https://github.com/marin-m/vmlinux-to-elf) utility.
