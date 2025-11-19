# Huawei E5785 mods and resources

This repository contains various modifications and resources for the Huawei
E5785 LTE modem.

It's mainly a collection of all my findings and personal mods for this device,
which I'm sharing to the world since I struggled a lot to find information about
it when I first got it.

## Credits

- The [Huawei-LTE-routers-mods](https://github.com/Huawei-LTE-routers-mods) org
  on GitHub, and @ValdikSS in particular, for being one of the very few people
  who publicly shared their knowledge to the community instead of hoarding it.
- @forth32 for the many tools and for also sharing great code and info:
    - [balong-usbdload](https://github.com/forth32/balong-usbdload)
    - [balongflash](https://github.com/forth32/balongflash)
    - [balong-nvtool](https://github.com/forth32/balong-nvtool)
- @alexbers
  for [huawei_oled_hijack_ng](https://github.com/alexbers/huawei_oled_hijack_ng)

## Forked utilities

Since many of the people in the Huawei modem hacking scene speak Russian, many
tools and resources are only available in that language.

I used AI to translate most of these tools to English, also making some
improvements along the way.

- [balong-usbdload](https://github.com/depau-forks/balong-usbdload)
- [balong-nvtool](https://github.com/depau-forks/balong-nvtool)
- [balongflash](https://github.com/depau-forks/balongflash)
- [qhuaweiflash](https://github.com/depau-forks/qhuaweiflash)

I additionally
forked [huawei_oled_hijack_ng](https://github.com/depau-forks/huawei_oled_hijack_ng)
to change the default menu items, removing some unwanted features.

I also shared my changes required to make modern dropbear build for this device:
[dropbear-balong](https://github.com/depau-forks/dropbear-balong).

## Included resources

- [rootfs patches](./rootfs_patches): patches to add useful tools and scripts
  to the modem's root filesystem.
- [usbloader](./usbdload): a usbloader image for backup, recovery and modding.
- [stock firmware](./stock_firmware): original firmware images I've had to 
  f\*\*\*ing pay to obtain. You may have them for free.
- [oled menu scripts](./oled_scripts): my custom scripts for the OLED menu
  hijack.
