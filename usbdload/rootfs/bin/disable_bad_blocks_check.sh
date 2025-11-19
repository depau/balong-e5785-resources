#!/bin/sh
set -eu

#
# This script patches out the following function by turning it into `return 0;`.
# https://elixir.bootlin.com/linux/v3.10.59/source/drivers/mtd/nand/nand_base.c#L452
#
#   00 00 A0 E3    mov r0, #0
#   1E FF 2F E1    bx  lr
#

echo "Finding address of 'nand_block_checkbad' function in kernel..."
addr="$(cat /proc/kallsyms | grep nand_block_checkbad | cut -d' ' -f 1)"

if [ -z "$addr" ]; then
    echo "Function not found, cannot continue." >&2
    exit 1
fi

addr="0x$addr"
echo "Found at address $addr, patching..."

printf '\x00\x00\xa0\xe3\x1e\xff\x2f\xe1' | dd of=/dev/kmem bs=1 seek="$(($addr))" conv=notrunc status=none || {
    echo "Patch failed, make sure that you are root and that /dev/kmem exists" >&2
    exit 1
}

echo "Done. To undo, reboot."

