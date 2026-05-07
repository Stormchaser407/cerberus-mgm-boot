---
project: Cerberus MGM Boot
type: project-doc
status: active
tags:
  - cerberus
  - git
  - codeberg
  - github
  - obsidian
---

# Repository Sync Runbook

Related docs: [[project_scope]], [[adb_terminal_workflow]], [[magisk_bootanimation_module]]

## Paths

Local repo:

```text
/mnt/storage/Cole/Projects/cerberus-mgm-boot
```

Obsidian mirror:

```text
/mnt/storage/Cole/main_vault/Projects/Cerberus MGM Boot
```

Pixel lab reference folder:

```text
/mnt/storage/Cole/Projects/pixel-root-lab
```

## Sync Docs To Obsidian

From the repo root:

```sh
./scripts/sync_to_obsidian.sh
```

The sync is docs-only. It copies curated Markdown documentation and `README.md`, writes `_sync_status.md`, and does not delete unrelated files in the Obsidian folder.

## Regenerate Manifest

From the repo root:

```sh
./scripts/write_manifest.sh
```

The manifest includes repository source files with sizes and sha256 hashes. It excludes `.git`, `reports/`, `downloads/`, generated build output, generated frame PNGs, and generated ZIP payloads.

## Add GitHub And Codeberg Remotes

Create empty repositories on GitHub and Codeberg first, then run:

```sh
GITHUB_URL="git@github.com:USERNAME/cerberus-mgm-boot.git" \
CODEBERG_URL="git@codeberg.org:USERNAME/cerberus-mgm-boot.git" \
./scripts/add_remotes.sh
```

Remote names:

- `main` = GitHub
- `codeberg` = Codeberg

The helper replaces old `origin`, `github`, `main`, and `codeberg` remotes before adding the current pair.

## Push Mirrors

From the repo root:

```sh
./scripts/sync_git.sh
```

The script detects the current branch and pushes to configured mirrors. If one mirror is missing, it reports that cleanly and still handles the configured mirror. If both are missing, it exits with setup instructions.

## Recovery If A Push Fails

Check remotes:

```sh
git remote -v
```

Confirm the destination repository exists and the URL is correct. Re-run `add_remotes.sh` if either URL is wrong.

If authentication failed, fix SSH access for the host that failed, then retry:

```sh
./scripts/sync_git.sh
```

If the remote contains unexpected commits, inspect before forcing anything:

```sh
git fetch --all --prune
git status
```

Do not force-push unless you intentionally decide the remote history should be replaced.

## Safety Boundary

Repository sync is documentation and Git setup only. Image generation, phone installs, direct system partition writes, and automatic reboots are not part of repo sync.
