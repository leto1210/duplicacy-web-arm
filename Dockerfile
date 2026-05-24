# Définir l'architecture cible (par défaut armv7)
ARG ARCH=armv7
ARG DUPLICACY_WEB_SHA256_ARM=b1a529eb1f102d3529002eb763f78934df2268c767f610c92e451e7a50035b8d
ARG DUPLICACY_WEB_SHA256_ARM64=ff611509d8d1ea7f5382a1f2681b597a64a4d845056b164c935bfdd217320836
ARG DUPLICACY_SHA256_ARM=34ba5c2953c3b3fb9ea383b014f286c7b646b2ea95e6d75d0da22e9b8ca4f919
ARG DUPLICACY_SHA256_ARM64=9c27d8ba149e67d0bc58406c6b3218661d870cb07e265aec31563540f8f20598

# Choisir l'image Alpine en fonction de l'architecture
FROM arm32v7/alpine:3.23.4 AS base-armv7
FROM arm64v8/alpine:3.23.4 AS base-arm64

# Utiliser l'image appropriée en fonction de $ARCH
FROM base-${ARCH} AS builder
LABEL maintainer="leto1210"
LABEL org.label-schema.vcs-url="e.g. https://github.com/leto1210/duplicacy-web-arm"

# Définit les versions des logiciels
ENV DUPLICACY_WEB_VERSION=1.8.3 \
    DUPLICACY_VERSION=3.2.5

# Set to actual USR_ID and GRP_ID of the user this should run under
# Uses root by default, unless changed
ENV USR_ID=0 \
    GRP_ID=0

ENV TZ="Europe/Paris"

# Installer les logiciels nécessaires
RUN apk update && \
    apk add --no-cache bash ca-certificates dbus su-exec tzdata wget

# Déterminer les bonnes URLs en fonction de l'architecture
ARG ARCH
ARG DUPLICACY_WEB_SHA256_ARM
ARG DUPLICACY_WEB_SHA256_ARM64
ARG DUPLICACY_SHA256_ARM
ARG DUPLICACY_SHA256_ARM64
RUN set -e; \
    case "$ARCH" in \
      armv7) DUPLICACY_WEB_ARCH="arm"; DUPLICACY_ARCH="arm"; DUPLICACY_WEB_SHA256="$DUPLICACY_WEB_SHA256_ARM"; DUPLICACY_SHA256="$DUPLICACY_SHA256_ARM" ;; \
      arm64) DUPLICACY_WEB_ARCH="arm64"; DUPLICACY_ARCH="arm64"; DUPLICACY_WEB_SHA256="$DUPLICACY_WEB_SHA256_ARM64"; DUPLICACY_SHA256="$DUPLICACY_SHA256_ARM64" ;; \
      *) echo "Architecture non prise en charge : $ARCH" >&2; exit 1 ;; \
    esac; \
    echo "Téléchargement pour $ARCH"; \
    if ! wget -nv -O /usr/local/bin/duplicacy_web "https://acrosync.com/duplicacy-web/duplicacy_web_linux_${DUPLICACY_WEB_ARCH}_${DUPLICACY_WEB_VERSION}"; then \
      echo "Échec du téléchargement de duplicacy_web pour $ARCH" >&2; exit 1; \
    fi; \
    if ! wget -nv -O /usr/local/bin/duplicacy "https://github.com/gilbertchen/duplicacy/releases/download/v${DUPLICACY_VERSION}/duplicacy_linux_${DUPLICACY_ARCH}_${DUPLICACY_VERSION}"; then \
      echo "Échec du téléchargement de duplicacy pour $ARCH" >&2; exit 1; \
    fi; \
    echo "${DUPLICACY_WEB_SHA256}  /usr/local/bin/duplicacy_web" | sha256sum -c -; \
    echo "${DUPLICACY_SHA256}  /usr/local/bin/duplicacy" | sha256sum -c -; \
    chmod +x /usr/local/bin/duplicacy_web /usr/local/bin/duplicacy; \
    rm -f /var/lib/dbus/machine-id; \
    ln -s /config/machine-id /var/lib/dbus/machine-id

# Réduire la taille de l'image
RUN rm -rf /var/lib/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

# Exposer le port et définir les volumes
EXPOSE 3875/tcp
VOLUME /config /logs /cache
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 CMD wget -q --spider --tries=1 --timeout=4 http://127.0.0.1:3875/ || exit 1

# Copier les scripts d'initialisation
COPY ./init.sh ./launch.sh /usr/local/bin/

# S'assurer que les scripts sont exécutables
RUN chmod +x /usr/local/bin/init.sh /usr/local/bin/launch.sh

# Définir le point d'entrée
ENTRYPOINT ["/usr/local/bin/init.sh"]
