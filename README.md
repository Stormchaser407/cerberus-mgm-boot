---
project: Cerberus MGM Boot
type: readme
status: active
tags:
  - cerberus
  - magisk
  - boot-animation
  - rooted-pixel
---

# Cerberus MGM Boot

A systemless Magisk boot animation project for the rooted Pixel / Cerberus phone build.

## Concept

A Cerberus-themed riff on the old movie-studio lion intro:

- circular studio-style crest
- three-headed guardian dog instead of a lion
- one head serious and watchful
- one head roaring
- one head smoking a cigar like an old bastard who has seen every bad idea twice
- noir / cel-shaded / cartoon grandeur
- Endgame / NotEvil / Cerberus flavor

## Target Device

Current target:

- Google Pixel 10 Pro XL
- Codename: mustang
- Android 16
- Root: Magisk
- Earlier detected screen size: 1344x2992

## Safety Rule

Do not overwrite system files directly.

Boot animations should be installed as Magisk modules so they remain reversible, disable-able, and recoverable.

Do not generate final Cerberus artwork during pipeline setup. Drop user-provided or separately authorized PNG frames into `bootanimation/part0/` and `bootanimation/part1/`.

## Boot Animation Pipeline

Build `bootanimation.zip` from local PNG frames:

```sh
./scripts/build_bootanimation_zip.sh
```

Package the reversible Magisk module:

```sh
./scripts/package_magisk_module.sh
```

Install the generated module ZIP through ADB and Magisk:

```sh
./scripts/install_module_adb.sh
```

Verify module staging:

```sh
./scripts/verify_module_adb.sh
```

Art intake:

```text
assets/source_art/      # source artwork inputs
bootanimation/part0/    # final intro frame PNGs
bootanimation/part1/    # final loop frame PNGs
```

Art generation is not run by default in this repo. See [[art_production_handoff]] in docs for approved final-art paths.

Disable or re-enable the module with Magisk flags:

```sh
./scripts/disable_module_adb.sh
./scripts/enable_module_adb.sh
```

## Repository Workflow

Sync docs to the Obsidian mirror:

```sh
./scripts/sync_to_obsidian.sh
```

Regenerate the repository manifest:

```sh
./scripts/write_manifest.sh
```

Add GitHub and Codeberg remotes after creating empty repos:

```sh
GITHUB_URL="git@github.com:USERNAME/cerberus-mgm-boot.git" \
CODEBERG_URL="git@codeberg.org:USERNAME/cerberus-mgm-boot.git" \
./scripts/add_remotes.sh
```

Push configured mirrors:

```sh
./scripts/sync_git.sh
```

Mirror remotes should be named `main` for GitHub and `codeberg` for Codeberg.
