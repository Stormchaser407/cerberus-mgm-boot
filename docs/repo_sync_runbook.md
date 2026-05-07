# Repository Sync Runbook

## Paths

Local repo:

```sh
/mnt/storage/Cole/Projects/cerberus-mgm-boot
```

Obsidian mirror:

```sh
/mnt/storage/Cole/main_vault/Projects/Cerberus MGM Boot
```

## Sync Docs To Obsidian

From the repo root:

```sh
./scripts/sync_to_obsidian.sh
```

This copies the curated documentation set and `README.md` into the Obsidian mirror, then writes `_sync_status.md`. It does not delete unrelated files in the Obsidian folder.

## Regenerate Manifest

From the repo root:

```sh
./scripts/write_manifest.sh
```

This rewrites `readme_manifest.md` with repository file paths, sizes, and sha256 hashes. The manifest excludes `.git`, transient `reports/` output, and the generated manifest file itself.

## Add Git Remotes

Create empty repositories on GitHub and Codeberg first, then run:

```sh
GITHUB_URL="git@github.com:USERNAME/cerberus-mgm-boot.git" \
CODEBERG_URL="git@codeberg.org:USERNAME/cerberus-mgm-boot.git" \
./scripts/add_remotes.sh
```

The script replaces old `github`, `codeberg`, and `origin` remotes, then adds the named mirror remotes:

- `github`
- `codeberg`

## Push Mirrors

From the repo root:

```sh
./scripts/sync_git.sh
```

The script detects the current branch and pushes it to any configured `github` and `codeberg` remotes. If one mirror is missing, it reports that and still pushes the configured mirror. If both are missing, it exits with setup instructions.

## Recovery If A Push Fails

1. Check configured remotes:

```sh
git remote -v
```

2. Confirm the destination repository exists and the URL is correct.

3. Re-run the remote setup command if either URL is wrong.

4. If authentication failed, fix SSH access for the host that failed, then retry:

```sh
./scripts/sync_git.sh
```

5. If the remote contains unexpected commits, inspect before forcing anything:

```sh
git fetch --all --prune
git status
```

Do not force-push unless you have intentionally decided the remote history should be replaced.

## Safety Boundary

Repository sync is documentation and Git setup only. Image generation, phone installs, and direct phone system file writes are not part of this workflow.
