---
project: Cerberus MGM Boot
type: project-doc
status: active
tags:
  - cerberus
  - adb
  - terminal
  - rooted-pixel
  - magisk
---

# ADB Terminal Workflow

Related docs: [[current_device_state]], [[magisk_bootanimation_module]], [[repo_sync_runbook]]

## Tooling

This workstation may not expose `adb` directly on `PATH`. The Cerberus scripts use `adb` when available and fall back to:

```sh
nix-shell -p android-tools --run 'adb ...'
```

## Core Commands

From the repo root:

```sh
./scripts/verify_module_adb.sh
./scripts/install_module_adb.sh
./scripts/disable_module_adb.sh
./scripts/enable_module_adb.sh
./scripts/reboot_and_check_adb.sh
```

`reboot_and_check_adb.sh` clearly reboots as part of its job. Other scripts do not reboot unless a clear flag is passed or the script text says so.

## Pixel Lab Helper Reference

Earlier terminal-control work lives here:

```text
/mnt/storage/Cole/Projects/pixel-root-lab/scripts/pixelctl.sh
```

Repo-local helper:

```sh
./scripts/pixelctl.sh help
```

Supported or documented commands:

- `health`
- `reboot`
- `systemui`
- `logs`
- `modules`
- `module-check MODULE_ID`
- `module-disable MODULE_ID`
- `module-enable MODULE_ID`
- `bootanim-check`
- `bootanim-disable`
- `bootanim-enable`
- `screenshot`
- `screenrecord-start`
- `screenrecord-stop`
- `install-apk`
- `open-url`
- `launch PACKAGE`
- `wake`
- `lock`
- `pull-report`

## Report Rule

Scripts that produce review output should write reports under:

```text
reports/
```

When `xclip` is available, useful report output should also be copied to the clipboard.

## Safe Module Toggle Pattern

Disable a module by touching its Magisk `disable` flag:

```sh
adb shell su -c 'touch /data/adb/modules/MODULE_ID/disable'
```

Re-enable by removing only that flag:

```sh
adb shell su -c 'rm -f /data/adb/modules/MODULE_ID/disable'
```

This is preferred over deleting module folders.
