# Custom scripts

## `disable_bad_blocks_check.sh`

This script disables the kernel's bad blocks checking feature by neutering the
function responsible for it at runtime.

Why would you want to do this? Mainly to allow re-flashing a full NAND image
with OOB data back onto a modem where the OOB data has been corrupted, causing
the blocks to be incorrectly marked as bad.

This allows fully erasing the partition and re-flashing a backup.
