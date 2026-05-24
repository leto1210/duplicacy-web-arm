# Maintenance Notes

This document captures practical maintenance lessons and operational conventions for the repository.

## Lessons Learned

- Pin GitHub Actions to commit SHAs to reduce supply-chain risk, even if local editors sometimes report false-positive resolution warnings.
- Organization allowlists for GitHub Actions can force workflow design changes; when necessary, prefer `git`, `gh`, or other built-in CLI tools over non-approved third-party actions.
- Avoid `install: true` with `docker/setup-buildx-action` unless the workflow really needs the `docker buildx` CLI installed globally. In this repository, `docker/build-push-action` is sufficient.
- Remove obsolete or disabled workflows when the replacement path is clear, to avoid confusion and maintenance drift.
- Keep `Dockerfile32` and `Dockerfile64` as documented legacy files only; the main build path and CI should continue to use `Dockerfile` with `ARCH`.
- Keep the README aligned with the actual repository state: Docker Hub registry link, active CI workflows, security scanning scope, and automated version update behavior.
- Scan both published images (`latest-armv7` and `latest-arm64`) rather than only one architecture to reflect real release coverage.
- Prefer simple and auditable automated update workflows that fetch upstream versions, modify tracked files, and create pull requests explicitly.
- Periodic cleanup of stale CI files, deprecated workflow options, and residual configuration files prevents confusion and reduces breakage.
- When automated version bumps change binary versions, the corresponding SHA256 ARG values must be updated at the same time — the update workflow now fetches and patches them automatically.
- Setting Trivy `exit-code: 0` silently hides fixable vulnerabilities; use `exit-code: 1` with `ignore-unfixed: true` so only actionable CVEs block CI.
- Pin base images to exact patch versions (e.g., `alpine:3.23.4` not `alpine:3.23`) for deterministic and reproducible builds. Update the patch version when Alpine releases a new patch.
- Legacy Dockerfiles (`Dockerfile32`, `Dockerfile64`) must maintain the same security controls as the main `Dockerfile` (SHA256 verification, binary integrity checks) even if they are not used in primary CI.
- A `.dockerignore` file should exclude `.git`, `.github`, legacy Dockerfiles, and documentation files to keep the build context minimal and avoid accidentally including sensitive or irrelevant files.

## Current CI Conventions

- Official image builds are handled by `.github/workflows/docker-image.yml` using `Dockerfile` and the `ARCH` build argument.
- Security scanning is handled by `.github/workflows/trivy.yml` for both `latest-armv7` and `latest-arm64`. Trivy fails the workflow (`exit-code: 1`) on fixable CRITICAL/HIGH CVEs; unfixed vulnerabilities are ignored (`ignore-unfixed: true`).
- Weekly version update automation is handled by `.github/workflows/update-duplicacy-versions.yml`. It updates both the version strings and the SHA256 checksums in all Dockerfiles.
- GitHub Actions workflow linting is handled by `.github/workflows/actionlint.yml`.
- Dependency review and Trivy DB cache refresh each have dedicated workflows.
- All GitHub Actions are pinned to full commit SHAs with a version comment (e.g., `# v4.2.0`). Update SHAs when upgrading action versions.

## Maintenance Guidelines

- Prefer removing dead workflows over keeping `.disabled` files unless they still provide real operational value.
- If repository policy restricts external actions, re-check all workflow dependencies before introducing new actions.
- Keep user-facing strings in French where applicable, but keep technical documentation and comments in English unless project conventions require otherwise.
- When modifying CI, update documentation in the same change if user-visible behavior or maintenance expectations change.
- When upgrading the Alpine base image patch version, update it in `Dockerfile`, `Dockerfile32`, and `Dockerfile64` together.
- When a new version of a GitHub Action is available, retrieve its commit SHA via `gh` or the GitHub API and update both the SHA and the version comment.
