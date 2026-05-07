---
project: Cerberus MGM Boot
type: project-doc
status: active
tags:
  - cerberus
  - tasker
  - macrodroid
  - rooted-pixel
  - automation
---

# Tasker And MacroDroid Starter Plan

Related docs: [[current_device_state]], [[adb_terminal_workflow]], [[magisk_bootanimation_module]]

These are starter automation ideas that complement terminal-first control. Do not implement on-phone Tasker or MacroDroid actions unless they are clearly safe and explicitly requested.

## Cerberus Boot Completed Routine

- Trigger: device boot completed
- Wait 30-60 seconds
- Show notification: `Cerberus online`
- Optional: launch Termux or Home
- Optional: start Tailscale if installed
- Optional: run a Termux:Boot script if Termux:Boot is installed

## Root Health Notification

- Trigger: manual shortcut or scheduled daily
- Run shell command:

```sh
su -c id
```

- If root works, notify: `Root online`
- If root fails, notify: `Root unavailable`

## ADB Pairing Helper

- Trigger: manual quick tile or home shortcut
- Open Developer Options or Wireless Debugging settings
- Show reminder notification with local recon project path:

```text
/mnt/storage/Cole/Projects/pixel-root-lab
```

## Chime PWA Launcher

- Trigger: manual shortcut
- Open Chime PWA or web URL
- Do not use the native Chime app
- Note: Chime app failed under the rooted max-power setup; the PWA works

## Cerberus Panic Mode

- Trigger: manual shortcut
- Open an innocuous app or the home screen
- Optional: open browser to a neutral page
- Do not delete data
- Do not wipe the device
- Do not uninstall anything

## Boot Animation Test Reminder

- Trigger: after reboot or manual
- Ask whether the boot animation displayed
- Show quick disable command:

```sh
cd /mnt/storage/Cole/Projects/cerberus-mgm-boot
nix-shell -p android-tools --run './scripts/disable_module_adb.sh'
```

## Module Disable Quick Note

- Trigger: manual shortcut
- Show command:

```sh
cd /mnt/storage/Cole/Projects/cerberus-mgm-boot
nix-shell -p android-tools --run './scripts/disable_module_adb.sh'
```

## Work Profile And User 10 Awareness

Some package queries return multiple UIDs because Android user 10 or a work profile may exist. Automation should default to user 0 unless intentionally dealing with the work profile.

## Do Not Automate Blind Module Installs

Tasker and MacroDroid should not auto-install Magisk modules. Module installation remains manual and terminal-controlled.
