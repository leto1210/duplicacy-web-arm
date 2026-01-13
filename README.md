# Duplicacy web container for ARM


![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/leto1210/duplicacy-web-arm)
[![Trivy security check](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/trivy.yml/badge.svg)](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/trivy.yml)
[![Dependency Review](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/dependency-review.yml/badge.svg?branch=master)](https://github.com/leto1210/duplicacy-web-arm/actions/workflows/dependency-review.yml)

Based on [saspus/duplicacy-web](https://bitbucket.org/saspus/duplicacy-web-docker-container/src/master/)

## ARM 32 bits or ARM 64 bits ?

By default, the "latest" tag on Docker Hub corresponds to the arm32v7 version. To verify this, you can check the tags on the [Docker Hub page](https://hub.docker.com/r/leto1210/duplicacy-web-arm/tags). If you need the 64-bit version, explicitly use the `arm64v8` tag when pulling the image.
If you need the 64 bits version, you must choose it explicitly.

## How To

``` bash
docker run  --name duplicacy-web-arm            \ # Container name
        -h duplicacy-web-arm                    \ # Hostname for the container
        -e TZ=Europe/Paris                      \ # Set timezone to Europe/Paris
        -p 3875:3875/tcp                        \ # Map port 3875 on the host to port 3875 in the container
        -e USR_ID=1000                          \ # Set user ID inside the container
        -e GRP_ID=1000                          \ # Set group ID inside the container
        -v ~/Library/Duplicacy:/config          \ # Mount local config directory to /config in the container
        -v ~/Library/Logs/Duplicacy/:/logs      \ # Mount local logs directory to /logs in the container
        -v ~/Library/Caches/Duplicacy:/cache    \ # Mount local cache directory to /cache in the container
        -v ~:/backuproot:ro                     \ # Mount home directory as read-only to /backuproot in the container
        --restart always                        \ # Always restart the container unless stopped manually
        leto1210/duplicacy-web-arm                # Docker image to use
```

## Source @saspus
https://bitbucket.org/saspus/duplicacy-web-docker-container
