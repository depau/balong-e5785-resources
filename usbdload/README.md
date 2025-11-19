# Workable usbloader image

`usbloader-shell-e5785-92c.bin` is a usb loader image for E5785 modems that runs
a
shell on the device.

The shell is accessible both via the physical UART pins and via the first
virtual serial port over USB.

The bundled ramdisk includes:

- A more complete and up-to-date build of `busybox`
- `lsz` and `lrz` for ZMODEM file transfers over serial
- `nanddump`, `nandwrite`, and `flash_erase` for NAND flash manipulation
- A [script to disable bad blocks checking](../scripts/)
- A patched partition table to prevent the modem's downstream kernel from being
  too smart about bad blocks.

The usbloader has been modified from [
`usblsafe-e5785.bin`](https://github.com/forth32/balong-usbdload/blob/master/usblsafe-e5785.bin).
It includes a patched partition table and a ramdisk with additional tools.

The usbloader can be booted from RAM
using [balong-usbdload](https://github.com/depau-forks/balong-usbdload/). My
fork translates it to English and adds tools to work with the partition table.

## About the partition table

> [!WARNING]
> The partition table used in this usbloader has been extracted from the 92c
> stock firmware. Writing to partitions using this table on other E5785 variants
> may cause data loss or bricking. Be sure to use the correct partition table
> for your specific device variant.

The partition table in the original `usblsafe-e5785.bin` image is slightly
different to the one used by the E5785-92c's stock firmware, so I extracted it
from a firmware update package and included it in this usbloader image.

`ptable-92c-original.bin` contains the original partition table extracted from
the stock firmware.

`ptable-92c-noweirdbehaviors.bin` is the same partition table, modified to
rename all partitions to `x_<original_name>`. Why, you may ask? Because the
E5785's downstream kernel pulls two amazing tricks with partitions it classifies
as "filesystem partitions":

- On boot, when the partition table is scanned, if it finds bad blocks at the
  start of a filesystem partition, it silently shifts the start of the partition
  forward to skip the bad blocks, shrinking the partition in the process.
- It performs additional check when reading and writing blocks in filesystem
  partitions. In particular, it rejects reads/writes larger than 2048 bytes that
  include the OOB area.

Both of these behaviors break standard NAND flash usage patterns especially
w.r.t. backing up and restoring full NAND images including OOB data.

Since the modified kernel classifies partitions as filesystem partitions based
on their names, renaming them to start with `x_` prevents these behaviors from
being applied.

The `disable_bad_blocks_check.sh` script included in the ramdisk can
additionally be used to disable the bad blocks checking feature at runtime,
allowing re-flashing of full NAND images including OOB data even if the OOB
data is corrupted.

## Dumping and restoring NAND flash

> [!WARNING]
> **Warning:** Writing to NAND flash can permanently brick your device if done
> incorrectly. Make sure you understand what you are doing, have a proper
> backup, and are pretty confident you will know how to recover if something
> goes wrong.

I will purposefully not go into details on how to dump and restore NAND flash
here, since you need to have a good understanding of what you are doing to avoid
bricking your device.

This should give you a general idea of the steps involved.

### Dumping NAND flash

You will want to create multiple dumps of your NAND flash, one for each
partition, with and without OOB data.

- Dump with OOB data:
  ```sh
  nanddump -o -f mtdX-oob.img /dev/mtdX --bb=dumpbad
  ```
- Dump without OOB data:
  ```sh
  nanddump -f mtdX.img /dev/mtdX --bb=dumpbad
  ```
- Dump the `mtdblockX` device (without OOB data):
  ```sh
  dd if=/dev/mtdblockX of=mtdblockX.img bs=2K
  ```

To fetch the dumps from the device to your computer, you can use `lsz` over the
serial connection. If you are using `minicom`, just run `lsz filename` to send
the file; `minicom` will automatically store it.

I recommend you perform multiple dumps of each partition and make sure the
checksums match. If they don't, try dumping again until you get consistent
results.

### Restoring NAND flash

If your OOB data is still intact, and you don't have any bad blocks, you can
restore the dumps without OOB data using `nandwrite`:

```sh
nandwrite -p /dev/mtdX nand_dump.bin
```

If your device reports bad blocks incorrectly due to corrupted OOB data, you
may, at your own risk, use the `disable_bad_blocks_check.sh` script to disable
bad blocks checking at runtime, allowing you to re-flash the full NAND image
including OOB data:

```sh
./disable_bad_blocks_check.sh
flash_erase /dev/mtdX 0 0
nandwrite -o -f mtdX-oob.img /dev/mtdX
```

Note that if the blocks are actually bad, writing to them may fail or cause data
corruption.

To send the dump files from your computer to the device, run `lrz` on the
device, then, in `minicom`, use `Ctrl+A` followed by `S` to send the file using
ZMODEM.

## Modifying the usbloader image

It's tricky. My fork of `balong-usbdload` includes a tool to unpack the boot
image, which allows obtaining the two binaries: `raminit` and loader.

The kernel image is an Android boot image, but I've had mixed results trying to
extract it, modify it and repack it consistently.

I usually use `binwalk` to find the very last CPIO archive in the usbloader
file, zero out the bytes from there to the end of the file with `dd`, then use
`dd` again to write a new CPIO archive in its place.

For instance:

```sh
dd if=/dev/zero conv=notrunc of=usbloader.bin seek=$((0x5A5F9C)) count=1122040 bs=1 status=progress
dd if=new.cpio.gz conv=notrunc of=usbloader.bin seek=$((0x5A5F9C)) bs=1 status=progress
```

To create a new CPIO archive, for instance from the [rootfs](./rootfs) included
in this repository, you can use:

```sh
cd rootfs
find . -print0 | fakeroot cpio --null -ov --format=newc | gzip -n --best > ../new.cpio.gz
```
