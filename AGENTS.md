# AGENTS.md

This file contains guidelines and commands for agentic coding agents working in the duplicacy-web-arm repository.

## Project Overview

This is a Docker container project that builds ARM-optimized images for Duplicacy Web, a backup solution. The project supports both ARM 32-bit (armv7) and ARM 64-bit (arm64) architectures using a unified multi-stage Dockerfile.

## Build Commands

### Docker Build Commands
```bash
# Build for ARM 32-bit (armv7)
docker build -t duplicacy-web-arm:armv7 --build-arg ARCH=armv7 .

# Build for ARM 64-bit (arm64)
docker build -t duplicacy-web-arm:arm64 --build-arg ARCH=arm64 .
```

### Test Commands
```bash
# Test container startup (armv7)
docker run --rm -p 3875:3875 -e USR_ID=1000 -e GRP_ID=1000 \
  -v /tmp/test-config:/config -v /tmp/test-logs:/logs \
  duplicacy-web-arm:armv7

# Test container startup (arm64)
docker run --rm -p 3875:3875 -e USR_ID=1000 -e GRP_ID=1000 \
  -v /tmp/test-config:/config -v /tmp/test-logs:/logs \
  duplicacy-web-arm:arm64
```

### Script Syntax Check
```bash
bash -n init.sh
bash -n launch.sh
```

## Code Style Guidelines

### Dockerfile Style
- Use multi-stage builds with architecture-specific base images
- Define build arguments at the top with clear defaults, including SHA256 ARG values for each architecture
- Group related RUN instructions with `&&` for layer optimization
- Use French comments where existing (maintain consistency)
- Keep environment variables grouped by purpose
- Pin base images to exact patch versions (e.g., `alpine:3.23.4`, not `alpine:3.23`)

### Shell Script Style
- Use `#!/usr/bin/env bash` shebang with `set -euo pipefail` and `IFS=$'\n\t'`
- Every function must have an English docstring comment: purpose, params, returns, errors
- Function names use snake_case with descriptive names
- Use quotes around variable expansions: `"$VAR"`
- Indent with 2 spaces (consistent with existing scripts)
- User-facing `echo` output must be in French; code, comments, and docstrings in English

### Security Requirements
- All downloaded binaries must be verified with `sha256sum -c` before `chmod +x`
- SHA256 values are stored as `ARG` at the top of each Dockerfile and must be updated with every version bump
- Run containers as non-root user when possible (USR_ID/GRP_ID via `su-exec`)
- Use minimal base images (Alpine Linux, pinned to exact patch version)
- Clean up apk caches and temp files in the same RUN layer as the install
- All GitHub Actions must be pinned to full commit SHAs with a `# vX.Y.Z` comment

### Version Management
- `DUPLICACY_WEB_VERSION` and `DUPLICACY_VERSION` are defined as `ENV` in each Dockerfile
- SHA256 ARG values for both architectures sit at the top of `Dockerfile`, `Dockerfile32`, and `Dockerfile64`
- When bumping versions manually: update the version strings **and** the SHA256 ARGs in all three Dockerfiles
- The weekly workflow (`update-duplicacy-versions.yml`) handles both version strings and SHA256 updates automatically

## Development Workflow

1. **Changes to Dockerfile**: Test builds for both architectures before committing
2. **Script changes**: Verify syntax with `bash -n`
3. **Version bumps**: Update version strings and SHA256 ARGs together in all three Dockerfiles
4. **CI changes**: Run `actionlint` locally or push to a branch to trigger the linting workflow
5. **Documentation**: Keep README.md, MAINTENANCE.md, AGENTS.md, and CLAUDE.md in sync with any behavioral changes

## Common Issues

- **SHA256 mismatch**: Ensure `ARG DUPLICACY_*_SHA256_*` values in all Dockerfiles match the actual binaries for the specified version
- **Architecture mismatch**: Ensure the correct `ARCH` build argument is passed
- **Permission errors**: Verify `USR_ID`/`GRP_ID` settings and that host volume directories exist with correct permissions
- **Download failures**: Check network connectivity and that the version exists at the upstream URLs

## Maintenance

- When Alpine releases a new patch (e.g., `3.23.5`), update the pinned tag in `Dockerfile`, `Dockerfile32`, and `Dockerfile64`
- When upgrading a GitHub Action, retrieve the new commit SHA via the GitHub API and update both the SHA and the version comment
- Monitor Duplicacy releases for security updates; the weekly workflow will open a PR automatically
