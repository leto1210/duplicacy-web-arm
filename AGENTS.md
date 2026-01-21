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

# Build using buildx for multi-platform
docker buildx build --platform linux/arm/v7,linux/arm64 -t duplicacy-web-arm:latest .
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

# Test with full volume mounts
docker run --name duplicacy-web-arm-test -h duplicacy-web-arm \
  -e TZ=Europe/Paris -p 3875:3875/tcp -e USR_ID=1000 -e GRP_ID=1000 \
  -v ~/Library/Duplicacy:/config -v ~/Library/Logs/Duplicacy/:/logs \
  -v ~/Library/Caches/Duplicacy:/cache -v ~:/backuproot:ro \
  --restart always duplicacy-web-arm:armv7
```

### CI/CD Commands
The project uses GitHub Actions for automated builds. The workflow is triggered on:
- Push to master branch
- Pull requests to master branch

## Code Style Guidelines

### Dockerfile Style
- Use multi-stage builds with architecture-specific base images
- Define build arguments at the top with clear defaults
- Group related RUN instructions with && for layer optimization
- Use French comments where existing (maintain consistency)
- Keep environment variables grouped by purpose
- Use specific version tags for base images (e.g., `alpine:3.23`)

### Shell Script Style
- Use `#!/usr/bin/env bash` shebang
- Function names use snake_case with descriptive names
- Error handling with explicit exit codes
- Use quotes around variable expansions: `"$VAR"`
- Indent with 2 spaces (consistent with existing scripts)
- Add echo statements for debugging and transparency

### File Organization
```
/
├── Dockerfile              # Main unified Dockerfile
├── Dockerfile32           # Legacy ARM 32-bit Dockerfile
├── Dockerfile64           # Legacy ARM 64-bit Dockerfile
├── init.sh                # Container initialization script
├── launch.sh              # Application launch script
├── README.md              # Project documentation
├── LICENSE                # MIT License
├── .github/
│   └── workflows/         # CI/CD configurations
└── .gitignore            # Git ignore patterns
```

### Naming Conventions
- **Images**: `duplicacy-web-arm:{version}-{arch}` and `duplicacy-web-arm:latest-{arch}`
- **Containers**: Use descriptive names with `-arm` suffix
- **Environment Variables**: UPPER_SNAKE_CASE (e.g., `USR_ID`, `GRP_ID`)
- **Shell Functions**: snake_case with descriptive names (e.g., `terminator`)
- **Files**: lowercase with underscores or hyphens

### Error Handling
- Always check download success with exit codes
- Use conditional logic for architecture-specific operations
- Implement proper signal handling in shell scripts
- Validate required directories and files exist
- Use explicit error messages with context

### Security Best Practices
- Run containers as non-root user when possible (USR_ID/GRP_ID)
- Use minimal base images (Alpine Linux)
- Clean up package caches and temporary files
- Avoid logging sensitive information
- Use read-only mounts where appropriate

### Version Management
- Duplicacy Web version: Defined in `DUPLICACY_WEB_VERSION` env var
- Duplicacy CLI version: Defined in `DUPLICACY_VERSION` env var
- Base image versions: Use specific tags (e.g., `alpine:3.23`)
- Update versions in Dockerfile, not in separate files

### Testing Guidelines
- Test both architectures (armv7 and arm64)
- Verify container startup and basic functionality
- Test volume mounts and permissions
- Validate configuration file generation
- Test with different user/group IDs

## Development Workflow

1. **Changes to Dockerfile**: Test builds for both architectures
2. **Script Changes**: Verify syntax with `bash -n`
3. **Version Updates**: Update env vars in Dockerfile
4. **CI Changes**: Test workflow syntax and triggers
5. **Documentation**: Keep README.md in sync with changes

## Common Issues

- **Architecture Mismatch**: Ensure correct ARCH build argument
- **Permission Errors**: Verify USR_ID/GRP_ID settings
- **Download Failures**: Check URLs and network connectivity
- **Volume Mounts**: Ensure host directories exist and have correct permissions

## Maintenance

- Regularly update base Alpine image versions
- Monitor Duplicacy releases for security updates
- Test new Docker versions for compatibility
- Review GitHub Actions workflow updates