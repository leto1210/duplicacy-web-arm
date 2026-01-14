# Duplicacy web container for ARM


![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/leto1210/duplicacy-web-arm)
[![Trivy security check](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/trivy.yml/badge.svg)](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/trivy.yml)
[![Dependency Review](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/dependency-review.yml/badge.svg?branch=master)](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/dependency-review.yml)

Based on [saspus/duplicacy-web](https://bitbucket.org/saspus/duplicacy-web-docker-container/src/master/)

## Supported Architectures

This project supports two ARM architectures:
- **ARM 32-bit (armv7)**: `leto1210/duplicacy-web-arm:latest-armv7`
- **ARM 64-bit (arm64)**: `leto1210/duplicacy-web-arm:latest-arm64`

By default, the "latest" tag on Docker Hub corresponds to the arm32v7 version.

## Local Build

To build the image locally with the unified Dockerfile:

```bash
# For 32-bit (armv7)
docker build -t duplicacy-web-arm:armv7 --build-arg ARCH=armv7 .

# For 64-bit (arm64)
docker build -t duplicacy-web-arm:arm64 --build-arg ARCH=arm64 .
```

## Usage

### From Docker Hub

```bash
# For 32-bit (armv7)
docker run  --name duplicacy-web-arm            \ # Container name
        -h duplicacy-web-arm                    \ # Container hostname
        -e TZ=Europe/Paris                      \ # Set timezone
        -p 3875:3875/tcp                        \ # Map port 3875
        -e USR_ID=1000                          \ # User ID inside the container
        -e GRP_ID=1000                          \ # Group ID inside the container
        -v ~/Library/Duplicacy:/config          \ # Configuration directory
        -v ~/Library/Logs/Duplicacy/:/logs      \ # Logs directory
        -v ~/Library/Caches/Duplicacy:/cache    \ # Cache directory
        -v ~:/backuproot:ro                     \ # Directory to backup (read-only)
        --restart always                        \ # Auto-restart
        leto1210/duplicacy-web-arm:latest-armv7   # Docker image

# For 64-bit (arm64)
docker run  --name duplicacy-web-arm            \
        -h duplicacy-web-arm                    \
        -e TZ=Europe/Paris                      \
        -p 3875:3875/tcp                        \
        -e USR_ID=1000                          \
        -e GRP_ID=1000                          \
        -v ~/Library/Duplicacy:/config          \
        -v ~/Library/Logs/Duplicacy/:/logs      \
        -v ~/Library/Caches/Duplicacy:/cache    \
        -v ~:/backuproot:ro                     \
        --restart always                        \
        leto1210/duplicacy-web-arm:latest-arm64   # Docker image
```

### From Local Build

```bash
# For 32-bit
docker run --name duplicacy-web-arm -h duplicacy-web-arm -e TZ=Europe/Paris \
  -p 3875:3875/tcp -e USR_ID=1000 -e GRP_ID=1000 \
  -v ~/Library/Duplicacy:/config -v ~/Library/Logs/Duplicacy/:/logs \
  -v ~/Library/Caches/Duplicacy:/cache -v ~:/backuproot:ro \
  --restart always duplicacy-web-arm:armv7

# For 64-bit
docker run --name duplicacy-web-arm -h duplicacy-web-arm -e TZ=Europe/Paris \
  -p 3875:3875/tcp -e USR_ID=1000 -e GRP_ID=1000 \
  -v ~/Library/Duplicacy:/config -v ~/Library/Logs/Duplicacy/:/logs \
  -v ~/Library/Caches/Duplicacy:/cache -v ~:/backuproot:ro \
  --restart always duplicacy-web-arm:arm64
```

## Source @saspus
https://bitbucket.org/saspus/duplicacy-web-docker-container
