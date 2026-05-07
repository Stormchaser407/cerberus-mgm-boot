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

Mirror remotes should be named `github` and `codeberg`.
