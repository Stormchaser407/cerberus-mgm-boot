---
project: Cerberus MGM Boot
type: project-doc
status: active
tags:
  - cerberus
  - rooted-pixel
  - android
  - magisk
  - device-state
---

# Current Device State

Related docs: [[adb_terminal_workflow]], [[magisk_bootanimation_module]], [[tasker_macrodroid_plan]]

## Device

- Model: Google Pixel 10 Pro XL
- Codename: `mustang`
- Android: 16
- Build seen earlier: `CP1A.260405.005`
- Screen size detected earlier: `1344x2992`

## Root And Module Context

- Magisk: 30.7 / 30700
- Root via ADB was confirmed earlier:

```text
uid=0(root) gid=0(root) context=u:r:magisk:s0
```

- Zygisk daemon active
- Vector / LSPosed-style daemon active
- PixelXpert installed but only partially compatible on this ROM
- MMRL installed successfully

## Banking And App Strategy

- Chime native app does not work with the rooted max-power setup.
- Chime PWA works and should be preferred.
- Do not neuter Vector solely to satisfy banking apps.
- Use Magisk DenyList as a hidelist, with DenyList enforcement off.

## PixelXpert Notes

PixelXpert v5.x rejected the ROM as incompatible. PixelXpert v4.3.0 installed and partially worked.

Working or seen:

- Advanced reboot features appeared

Not working or unreliable:

- clock/status bar changes
- battery bar
- battery status methods around `BatteryStatus/getChargingSpeed`

## Launcher Notes

Nova Launcher was disabled for user 0, not uninstalled. Pixel Launcher was confirmed active.

## Related Terminal Control

Pixel lab helper:

```text
/mnt/storage/Cole/Projects/pixel-root-lab/scripts/pixelctl.sh
```

Cerberus repo helpers:

```text
/mnt/storage/Cole/Projects/cerberus-mgm-boot/scripts/
```
