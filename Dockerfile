# Définir l'architecture cible (par défaut armv7)
ARG ARCH=armv7

# Choisir l'image Alpine en fonction de l'architecture
FROM arm32v7/alpine:3.23 AS base-armv7
FROM arm64v8/alpine:3.23 AS base-arm64

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
ARG ARCH=armv7
RUN if [ "$ARCH" = "armv7" ]; then \
      DUPLICACY_WEB_ARCH="arm" && \
      DUPLICACY_ARCH="arm"; \
    elif [ "$ARCH" = "arm64" ]; then \
      DUPLICACY_WEB_ARCH="arm64" && \
      DUPLICACY_ARCH="arm64"; \
    else \
      echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    echo "Downloading for $ARCH" && \
    wget -nv -O /usr/local/bin/duplicacy_web https://acrosync.com/duplicacy-web/duplicacy_web_linux_${DUPLICACY_WEB_ARCH}_${DUPLICACY_WEB_VERSION} 2>&1 && \
    if [ $? -ne 0 ]; then echo "Failed to download duplicacy_web for $ARCH" && exit 1; fi && \
    wget -nv -O /usr/local/bin/duplicacy https://github.com/gilbertchen/duplicacy/releases/download/v${DUPLICACY_VERSION}/duplicacy_linux_${DUPLICACY_ARCH}_${DUPLICACY_VERSION} 2>&1 && \
    if [ $? -ne 0 ]; then echo "Failed to download duplicacy for $ARCH" && exit 1; fi

RUN chmod +x /usr/local/bin/duplicacy_web /usr/local/bin/duplicacy && \
    rm -f /var/lib/dbus/machine-id && ln -s /config/machine-id /var/lib/dbus/machine-id

# Réduire la taille de l'image
RUN rm -rf /var/lib/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

# Exposer le port et définir les volumes
EXPOSE 3875/tcp
VOLUME /config /logs /cache

# Copier les scripts d'initialisation
COPY ./init.sh ./launch.sh /usr/local/bin/

# S'assurer que les scripts sont exécutables
RUN chmod +x /usr/local/bin/init.sh /usr/local/bin/launch.sh

# Définir le point d'entrée
ENTRYPOINT ["/usr/local/bin/init.sh"]
