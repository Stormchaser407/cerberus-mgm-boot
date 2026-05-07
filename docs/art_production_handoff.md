---
project: Cerberus MGM Boot
type: project-doc
status: active
tags:
  - cerberus
  - art-production
  - boot-animation
  - magisk
---

# Art Production Handoff

Related docs: [[concept]], [[frame_plan]], [[project_scope]], [[magisk_bootanimation_module]]

## Purpose

This document defines how real Cerberus boot animation art enters the pipeline without surprise generation or unsafe shortcuts.

## Approved Paths For Final Cerberus Art

1. User-provided source artwork placed in:

```text
/mnt/storage/Cole/Projects/cerberus-mgm-boot/assets/source_art/
```

2. Explicitly authorized image generation in a dedicated user-approved step.

3. Hand-drawn or vector artwork created in a deliberate separate art-production pass.

## Creative Direction Boundary

Style target is a movie-studio crest parody with Cerberus:

- circular studio-style crest
- three-headed guardian dog
- one sentinel head
- one roaring theatrical head
- one amused cigar-smoking head
- cel-shaded / cartoon noir / graphic novel energy

The project should avoid direct copyrighted logo copying. Keep the tone inspired by classic intros while remaining an original parody identity.

## Pipeline Art Locations

Source references:

```text
assets/source_art/
```

Final animation frames used for packaging:

```text
bootanimation/part0/
bootanimation/part1/
```

Build/package/install flow:

```sh
./scripts/build_bootanimation_zip.sh
./scripts/package_magisk_module.sh
./scripts/install_module_adb.sh
./scripts/verify_module_adb.sh
```

## Placeholder Art Rule

Placeholder frames are temporary test assets only. They may be generated procedurally with terminal tools if needed and clearly labeled as placeholder/test art. They are not final Cerberus artwork.
