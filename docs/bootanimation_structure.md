---
project: Cerberus MGM Boot
type: project-doc
status: active
tags:
  - cerberus
  - magisk
  - boot-animation
  - android
---

# Boot Animation Structure

Related docs: [[frame_plan]], [[magisk_bootanimation_module]], [[adb_terminal_workflow]]

Android boot animations use a ZIP file named:

    bootanimation.zip

The ZIP contains:

    desc.txt
    part0/
    part1/

Example desc.txt:

    1344 2992 30
    p 1 0 part0
    c 0 0 part1

Meaning:

- 1344 2992 = screen resolution
- 30 = frames per second
- p 1 0 part0 = play part0 once
- c 0 0 part1 = loop part1 continuously until boot completes

## Magisk Module Paths

Common overlay paths:

    system/media/bootanimation.zip
    system/product/media/bootanimation.zip

The module should not directly modify /system or /product.
