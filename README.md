# Duplicacy web container for ARM



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
