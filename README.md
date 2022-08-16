# Duplicacy web container for ARM


[![Build Status](https://travis-ci.com/leto1210/duplicacy-web-arm.svg?branch=master)](https://travis-ci.com/github/leto1210/duplicacy-web-arm)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)]
![Docker Pulls](https://img.shields.io/docker/pulls/leto1210/duplicacy-web-arm)
![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/leto1210/duplicacy-web-arm/build/master)

Based on [saspus/duplicacy-web](https://bitbucket.org/saspus/duplicacy-web-docker-container/src/master/)

## How To

``` bash
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
        leto1210/duplicacy-web-arm
```

## Source @saspus
https://bitbucket.org/saspus/duplicacy-web-docker-container
