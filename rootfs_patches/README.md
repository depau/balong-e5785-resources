# Modem rootfs patches

Here is a bunch of files to copy over the root filesystem of the modem used in
order to add useful tools and scripts.

I
used [Huawei-LTE-routers-mods/Huawei_E5785_fw_bake](https://github.com/Huawei-LTE-routers-mods/Huawei_E5785_fw_bake)
as a starting point to build this.

Included patches:

- A [modified](https://github.com/depau-forks/huawei_oled_hijack_ng) version
  of [huawei_oled_hijack_ng](https://github.com/depau-forks/huawei_oled_hijack_ng).
  It adds a customizable advanced menu that can be accessed by long-pressing the
  menu button.
- Custom startup and poweroff splash screens.
- A recent version of `dropbear` with support for ED25519 keys.
- A more complete and up-to-date build of `busybox` (at `busyboxx` to avoid)
  conflicts with the stock busybox binary).
- Prometheus exporter for monitoring.
- `atc` tool for sending AT commands to the modem's baseband.
- `nanddump`, `nandwrite`, and `flash_erase` for NAND flash manipulation.
- MicroPython

> [!WARNING]
> Do not ever pull the battery from the modem right after writing anything to
> NAND flash. Always flush and either reboot or wait a minute before removing
> power. Failing to do so may severely corrupt the NAND flash, requiring complex
> recovery.

## Usage

### Getting root access

Before starting, use the [usbloader](../usbdload) to get a full NAND dump.

To obtain root access on the modem, you can enable `telnetd` on boot in the
main firmware.

From the usb loader shell:

```sh
# Check /proc/mtd to find the correct mtdblock for the system partition
mount -t yaffs2 /dev/mtdblock27 /system
cp /bin/busybox /system/bin/busyboxx
chmod 755 /system/etc/autorun.sh
echo 'busyboxx telnetd -l /bin/sh -p 2323 &' >> /system/etc/autorun.sh
```

Then unmount the `/system` partition, sync and reboot:

```sh
umount /system
sync
reboot
```

You should now be able to connect via telnet to port 2323 after the modem boots.

```sh
telnet 192.168.8.1 2323
```

### Modifying the root filesystem

First of all, you must remount read-write the `/system` and `/app` partitions.

```sh
mount -o remount,rw /system
mount -o remount,rw /app
```

`before_script.sh` should be copied to the device in `/tmp` and executed
**before** copying the other files, as the other files will otherwise overwrite
important binaries that need to be backed up first.

You may use the Python HTTP server to serve the files from your computer:

```sh
python3 -m http.server 8000
```

Then, on the modem shell:

```sh
cd /tmp
wget http://192.168.8.100:8000/before_script.sh
chmod 755 before_script.sh
./before_script.sh
```

In your computer, pack the patches into a tarball:

```sh
./archive.sh
```

Then, on the modem shell, download and extract the tarball:

```sh
wget http://192.168.8.100:8000/patches.tar.gz
```

Double-check the contents of the tarball:

```sh
tar -tvzf patches.tar.gz
```

If everything looks good, extract it to the root filesystem:

```sh
tar -xvzf patches.tar.gz -C /
```

Finally, sync and reboot:

```sh
sync
reboot
```

## Build MicroPython

Install NDK 25.2.9519653; then, in a MicroPython clone:

```bash
NDK_PATH="$HOME/Android/Sdk/ndk/25.2.9519653/toolchains/llvm/prebuilt/linux-x86_64/bin"

# Add a symlink to the generic llvm-strip to allow cross-compilation
pushd "$NDK_PATH"
ln -s llvm-strip strip
popd

export PATH="$NDK_PATH:$PATH"
```

Then, to build MicroPython without FFI support:

```
cd ports/unix
make CC='armv7a-linux-androideabi19-clang' CXX='armv7a-linux-androideabi19-clang++' LIBPTHREAD='' MICROPY_STANDALONE=1 MICROPY_PY_FFI=0 -j$(nproc)
```

To build with FFI support

```bash
cd ports/unix

# Build libffi
git clone https://github.com/libffi/libffi.git
cd libffi
mkdir build && cd build
../configure --host=armv7a-linux-androideabi19 CC=armv7a-linux-androideabi19-clang CXX=armv7a-linux-androideabi19-clang++
make -j$(nproc)

cd ../..
make CC='armv7a-linux-androideabi19-clang' CXX='armv7a-linux-androideabi19-clang++' LIBPTHREAD='' MICROPY_PY_FFI=1 LDFLAGS_EXTRA='-L./libffi/build/.libs -l:libffi.a' CFLAGS_EXTRA='-isystem ./libffi/build/include' -j(nproc)
```
