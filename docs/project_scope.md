---
project: Cerberus MGM Boot
type: project-doc
status: active
tags:
  - cerberus
  - magisk
  - boot-animation
  - rooted-pixel
  - project-scope
---

# Project Scope

Related docs: [[concept]], [[production_notes]], [[repo_sync_runbook]]

## Purpose

Cerberus MGM Boot is a terminal-first rooted Pixel customization project centered on a reversible Magisk boot animation module.

The project builds and documents the pipeline for:

- creating Android `bootanimation.zip` files from local PNG frame folders
- packaging the animation as a systemless Magisk module
- installing, verifying, disabling, and re-enabling the module through ADB
- mirroring project documentation into Obsidian
- preparing the repo for GitHub and Codeberg mirroring

## Current Art Boundary

Do not generate final Cerberus artwork in this pipeline phase.

Temporary procedural placeholder frames are allowed only for packaging tests and must be clearly labeled as temporary test art. Final animation work requires one of:

- user-provided source art in `assets/source_art/`
- explicitly authorized image generation
- hand-drawn or vector assets created in a separate deliberate art-production step

## Primary Paths

Repo:

```text
/mnt/storage/Cole/Projects/cerberus-mgm-boot
```

Pixel lab reference folder:

```text
/mnt/storage/Cole/Projects/pixel-root-lab
```

Obsidian mirror:

```text
/mnt/storage/Cole/main_vault/Projects/Cerberus MGM Boot
```

## Frame Drop Folders

Drop source PNG frames into:

```text
bootanimation/part0/
bootanimation/part1/
```

Then run:

```sh
./scripts/build_bootanimation_zip.sh
./scripts/package_magisk_module.sh
./scripts/install_module_adb.sh
```

## Safety Rules

- Do not overwrite phone system files directly.
- Do not install random or untrusted Magisk modules.
- Do not auto-reboot unless a script clearly says it will reboot.
- Prefer reversible Magisk disable flags over uninstall behavior.
- Keep reports under `reports/`.
- Keep generated ZIPs and frame assets out of Git unless intentionally promoted.
