
FROM arm32v7/alpine:3.20.1

LABEL maintainer="leto1210"
LABEL org.label-schema.vcs-url="e.g. https://github.com/leto1210/duplicacy-web-arm"

ENV DUPLICACY_WEB_VERSION=1.8.0
ENV DUPLICACY_VERSION=3.2.3

# Set to actual USR_ID and GRP_ID of the user this should run under
# Uses root by default, unless changed

ENV USR_ID=0 \
    GRP_ID=0

ENV TZ="Europe/Paris"

# Installing software


RUN apk update
RUN apk add --no-cache bash ca-certificates dbus su-exec tzdata

RUN wget -nv -O /usr/local/bin/duplicacy_web https://acrosync.com/duplicacy-web/duplicacy_web_linux_arm_${DUPLICACY_WEB_VERSION} 2>&1 && \
    chmod +x /usr/local/bin/duplicacy_web && \
    rm -f /var/lib/dbus/machine-id && ln -s /config/machine-id /var/lib/dbus/machine-id && \
    wget -nv -O /usr/local/bin/duplicacy https://github.com/gilbertchen/duplicacy/releases/download/v${DUPLICACY_VERSION}/duplicacy_linux_arm_${DUPLICACY_VERSION} 2>&1 && \
    chmod +x /usr/local/bin/duplicacy

# Reduce  container size

RUN rm -rf /var/lib/apk/* && \
    rm -rf /tmp/*

EXPOSE 3875/tcp
VOLUME /config /logs /cache

COPY ./init.sh ./launch.sh /usr/local/bin/

ENTRYPOINT /usr/local/bin/init.sh
