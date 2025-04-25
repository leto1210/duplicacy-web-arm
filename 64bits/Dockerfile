# Définir l'architecture cible (par défaut arm64)
# Vous pouvez passer `--build-arg ARCH=armv7` pour construire une image 32 bits
#ARG ARCH=arm64

# Choisir l'image Alpine en fonction de l'architecture
FROM alpine:3.18 AS base-arm64
FROM alpine:3.18 AS base-armv7

# Utiliser l'image appropriée en fonction de $ARCH
FROM base-${ARCH} AS final

# Définit les versions des logiciels
ENV DUPLICACY_WEB_VERSION=1.8.3 \
    DUPLICACY_VERSION=3.2.4

# Set to actual USR_ID and GRP_ID of the user this should run under
# Uses root by default, unless changed
ENV USR_ID=0 \
    GRP_ID=0

ENV TZ="Europe/Paris"

# Installer les logiciels nécessaires
RUN apk update && \
    apk add --no-cache bash ca-certificates dbus su-exec tzdata wget

# Télécharger les binaires appropriés en fonction de l'architecture
RUN if [ "$ARCH" = "arm64" ]; then \
        wget -nv -O /usr/local/bin/duplicacy_web https://acrosync.com/duplicacy-web/duplicacy_web_linux_arm64_${DUPLICACY_WEB_VERSION} 2>&1 && \
        wget -nv -O /usr/local/bin/duplicacy https://github.com/gilbertchen/duplicacy/releases/download/v${DUPLICACY_VERSION}/duplicacy_linux_arm64_${DUPLICACY_VERSION} 2>&1; \
    elif [ "$ARCH" = "armv7" ]; then \
        wget -nv -O /usr/local/bin/duplicacy_web https://acrosync.com/duplicacy-web/duplicacy_web_linux_arm_${DUPLICACY_WEB_VERSION} 2>&1 && \
        wget -nv -O /usr/local/bin/duplicacy https://github.com/gilbertchen/duplicacy/releases/download/v${DUPLICACY_VERSION}/duplicacy_linux_arm_${DUPLICACY_VERSION} 2>&1; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    chmod +x /usr/local/bin/duplicacy_web /usr/local/bin/duplicacy && \
    rm -f /var/lib/dbus/machine-id && ln -s /config/machine-id /var/lib/dbus/machine-id

# Réduire la taille de l'image
RUN rm -rf /var/lib/apk/* && \
    rm -rf /tmp/* \
    rm -rf /var/cache/apk/*

# Exposer le port et définir les volumes
EXPOSE 3875/tcp
VOLUME /config /logs /cache

# Copier les scripts d'initialisation
COPY ./init.sh ./launch.sh /usr/local/bin/

# Définir le point d'entrée
ENTRYPOINT /usr/local/bin/init.sh