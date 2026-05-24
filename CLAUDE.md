# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker image project packaging [Duplicacy Web](https://duplicacy.com/) for ARM architectures (armv7 and arm64), based on Alpine Linux. There is no application source code — the repository consists entirely of shell scripts, Dockerfiles, and CI workflows.

## Build Commands

```bash
# Build for ARM 32-bit (armv7)
docker build -t duplicacy-web-arm:armv7 --build-arg ARCH=armv7 .

# Build for ARM 64-bit (arm64)
docker build -t duplicacy-web-arm:arm64 --build-arg ARCH=arm64 .
```

There are no tests, linters, or formatters to run locally. CI handles workflow linting via `actionlint`.

## Architecture

The main `Dockerfile` handles both architectures via `ARG ARCH=armv7` and multi-stage `FROM base-${ARCH}` selection. `Dockerfile32` and `Dockerfile64` are legacy/reference files only — do not use them for new builds.

Container startup is a two-script chain:
- **`init.sh`** — runs as root: validates prerequisites, resets `/etc/passwd`/`/etc/group`, creates the `duplicacy` user/group from `USR_ID`/`GRP_ID`, sets directory ownership, generates/validates the dbus machine-id, then `su-exec`s into `launch.sh`
- **`launch.sh`** — runs as the target user: validates binaries and directory writability, creates default `settings.json` and `duplicacy.json` if absent, tails the log, then `exec duplicacy_web`

Binary integrity is verified at build time via `sha256sum`. SHA256 hashes are stored as `ARG` values at the top of `Dockerfile` — update them alongside version bumps.

## Version Updates

When bumping `DUPLICACY_WEB_VERSION` or `DUPLICACY_VERSION`, update **all three** files: `Dockerfile`, `Dockerfile32`, `Dockerfile64`, and `README.md`. The weekly CI workflow (`update-duplicacy-versions.yml`) automates this and opens a PR. SHA256 hashes must also be updated manually in `Dockerfile` when versions change.

## CI Workflows

| Workflow | Trigger | Purpose |
|---|---|---|
| `docker-image.yml` | push/PR to master (non-`.github/` paths) | Build and push both arch images to Docker Hub |
| `trivy.yml` | scheduled + push | Scan `latest-armv7` and `latest-arm64` for vulnerabilities |
| `update-duplicacy-versions.yml` | weekly Monday 06:00 UTC | Check upstream releases and open PRs |
| `actionlint.yml` | push/PR | Lint all workflow YAML files |
| `dependency-review.yml` | PR | Review dependency changes |

CI runs on `self-hosted` runners (ARM). All GitHub Actions are pinned to commit SHAs.

## Coding Conventions

- **Language split**: code and comments in English; user-facing messages (shell `echo` output visible at runtime) in French.
- Shell scripts use `set -euo pipefail` and `IFS=$'\n\t'`. Every function has an English docstring comment block (purpose, params, returns, errors).
- Do not introduce new external GitHub Actions without checking the organization allowlist first. Prefer `git`, `gh`, or inline shell over third-party actions.
- Keep `Dockerfile32`/`Dockerfile64` in sync with `Dockerfile` for version strings only — do not add new features to them.
