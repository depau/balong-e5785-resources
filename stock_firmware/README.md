# Stock firmware images

> [!NOTE]
> **Note:** These firmware images are not sufficient to fully recover a bricked
> Huawei E5785 modem. You should dump the NAND flash entirely before making any
> modifications.

Stock firmware images for the Huawei E5785 modem.

## `E5785-92c 10.0.1.1(H191SP5C983)_Firmware_general_05016GEW.zip`

`E5785_10.0.1.1(H191SP5C983)-sec.BIN`

A somewhat complete stock firmware package for the E5785-92c variant.

```
 Firmware file code: b (FW_ISO)

 Digital signature: 4014 bytes
 Public key hash: 44C7B100763BF828B13B8B6AECF1ED2A6D3CB2888998F41448B276207B0F4EC4
 Firmware version: 1001.191.1.5.983
 Platform:         E5785N__0
 Build date:       2019.07.04 06:34:45
 Header: version 1, compatibility code: HWEW11.1

 ## Offset    Size      Compression     Name
-----------------------------------------------
 00 0000005c   301306              Fastboot
 01 00049a4c    18744              M3Boot_R11
 02 0004e3f0     2048              M3Boot-ptable
 03 0004ec54    68152              M3Image_R11
 04 0005f710   329856              DTS_R11
 05 000b0094  3381504              Teeos
 06 003ea06c  7235840              Kernel_R11
 07 00ad179c 16768000              Modem_fw
 08 01ad13fc  2221886              Nvdload_R11
 09 01ceffdc    65536              Logo
 10 01d00060 11875840              System
 11 02854d6c  7733248              APP
 12 02fb5c90      128              Oeminfo
 13 02fb5d74  5634048              CDROMISO
 ```

## `E5785-92c-WEBUI 10.0.1.1(W11SP4C03) Client Software general 05015SSF.zip`

`WEBUI_10.0.1.1(W11SP4C03)-sec.BIN`

I'm not sure this firmware is legit, as the digital signature doesn't match the
public key hash.

Extracting the firmware also reveals the real WebUI version is
`WEBUI 8.0.1.32(W0SP3C03)`, which can be obtained from
`WebApp/common/config/version.xml`.

I haven't fully investigated whether any malicious modifications were made to
this firmware, but it does nonetheless contain a complete WebUI image.

```
 Firmware file code: c (ONLY_WEBUI)

 Digital signature: 846 bytes
 Public key hash: 44C7B100763BF828B13B8B6AECF1ED2A6D3CB2888998F41448B276207B0F4EC4
 Firmware version: input
 Build date:       2019.06.03 10:16:48
 Header: version 1, compatibility code: HWEW11.1

 ## Offset    Size      Compression     Name
-----------------------------------------------
 00 0000005c     1878              Oeminfo
 01 00000818 11177472              WEBUI
```
