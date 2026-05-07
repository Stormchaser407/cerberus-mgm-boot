---
project: Cerberus MGM Boot
type: project-doc
status: active
tags:
  - cerberus
  - magisk
  - boot-animation
  - adb
  - module
---

# Magisk Boot Animation Module

Related docs: [[bootanimation_structure]], [[adb_terminal_workflow]], [[current_device_state]]

## Module ID

```text
cerberus_mgm_bootanimation
```

## Generated Module Paths

The packaged Magisk module places `bootanimation.zip` into both common overlay paths:

```text
system/media/bootanimation.zip
system/product/media/bootanimation.zip
```

This is systemless overlay behavior. The scripts must not write directly to `/system` or `/product`.

## Build Flow

Drop PNG frames into:

```text
bootanimation/part0/
bootanimation/part1/
```

Build the Android animation ZIP:

```sh
./scripts/build_bootanimation_zip.sh
```

Package the Magisk module:

```sh
./scripts/package_magisk_module.sh
```

Install manually through ADB and Magisk:

```sh
./scripts/install_module_adb.sh
```

The install script does not reboot automatically unless passed a clear reboot flag.

## Verify

```sh
./scripts/verify_module_adb.sh
```

The verifier checks:

- `/data/adb/modules/cerberus_mgm_bootanimation`
- `/data/adb/modules_update/cerberus_mgm_bootanimation`
- `module.prop`
- `bootanimation.zip` in both expected overlay locations
- `disable`, `update`, and `remove` flags

## Disable Or Re-Enable

Disable:

```sh
./scripts/disable_module_adb.sh
```

Enable:

```sh
./scripts/enable_module_adb.sh
```

Reboot afterward for Magisk module state changes to fully apply.

## Previous Test Module

The earlier Pixel lab test module used:

```text
cerberus_bootanimation
```

Its local staging folder was:

```text
/mnt/storage/Cole/Projects/pixel-root-lab/modules/cerberus_bootanimation
```

That test module packaged `bootanimation.zip` into both `system/media/` and `system/product/media/`. The production pipeline in this repo uses the new module ID `cerberus_mgm_bootanimation`.

ADB verification on 2026-05-06 found the old `cerberus_bootanimation` test module staged but not fully active:

- `/data/adb/modules/cerberus_bootanimation` exists with `module.prop` and an `update` flag
- active module folder is missing both bootanimation ZIP overlay files
- `/data/adb/modules_update/cerberus_bootanimation` contains both expected bootanimation ZIP paths

This indicates the old test module is pending activation on reboot. Do not reboot just to activate it unless that is the explicit test goal.
