# Duplicacy web container for ARM


![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/leto1210/duplicacy-web-arm)
[![Docker Image CI](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/docker-image.yml/badge.svg)](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/docker-image.yml)
[![Trivy security check](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/trivy.yml/badge.svg)](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/trivy.yml)
[![Dependency Review](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/dependency-review.yml/badge.svg?branch=master)](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/dependency-review.yml)

Based on [saspus/duplicacy-web](https://bitbucket.org/saspus/duplicacy-web-docker-container/src/master/)

## Supported Architectures

This project supports two ARM architectures:

| Architecture | Tag |
|---|---|
| ARM 32-bit (armv7) | `leto1210/duplicacy-web-arm:latest-armv7` |
| ARM 64-bit (arm64) | `leto1210/duplicacy-web-arm:latest-arm64` |

Versioned tags are also available in the form `leto1210/duplicacy-web-arm:<sha>-armv7` and `leto1210/duplicacy-web-arm:<sha>-arm64`.

## Software Versions

| Software | Version |
|---|---|
| duplicacy-web | 1.8.3 |
| duplicacy | 3.2.5 |

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `USR_ID` | `0` (root) | UID the service runs as |
| `GRP_ID` | `0` (root) | GID the service runs as |
| `TZ` | `Europe/Paris` | Container timezone |

## Local Build

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
docker run  --name duplicacy-web-arm            \
        -h duplicacy-web-arm                    \
        -e TZ=Europe/Paris                      \
        -p 3875:3875/tcp                        \
        -e USR_ID=1000                          \
        -e GRP_ID=1000                          \
        -v /path/to/config:/config              \
        -v /path/to/logs:/logs                  \
        -v /path/to/cache:/cache                \
        -v /path/to/backup:/backuproot:ro       \
        --restart always                        \
        leto1210/duplicacy-web-arm:latest-armv7

# For 64-bit (arm64)
docker run  --name duplicacy-web-arm            \
        -h duplicacy-web-arm                    \
        -e TZ=Europe/Paris                      \
        -p 3875:3875/tcp                        \
        -e USR_ID=1000                          \
        -e GRP_ID=1000                          \
        -v /path/to/config:/config              \
        -v /path/to/logs:/logs                  \
        -v /path/to/cache:/cache                \
        -v /path/to/backup:/backuproot:ro       \
        --restart always                        \
        leto1210/duplicacy-web-arm:latest-arm64
```

### From Local Build

```bash
# For 32-bit
docker run --name duplicacy-web-arm -h duplicacy-web-arm -e TZ=Europe/Paris \
  -p 3875:3875/tcp -e USR_ID=1000 -e GRP_ID=1000 \
  -v /path/to/config:/config -v /path/to/logs:/logs \
  -v /path/to/cache:/cache -v /path/to/backup:/backuproot:ro \
  --restart always duplicacy-web-arm:armv7

# For 64-bit
docker run --name duplicacy-web-arm -h duplicacy-web-arm -e TZ=Europe/Paris \
  -p 3875:3875/tcp -e USR_ID=1000 -e GRP_ID=1000 \
  -v /path/to/config:/config -v /path/to/logs:/logs \
  -v /path/to/cache:/cache -v /path/to/backup:/backuproot:ro \
  --restart always duplicacy-web-arm:arm64
```

## Source @saspus
https://bitbucket.org/saspus/duplicacy-web-docker-container
