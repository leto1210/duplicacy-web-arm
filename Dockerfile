
# FROM arm32v7/debian:11.4
FROM arm32v7/alpine:3.16.2

LABEL maintainer="leto1210"
LABEL org.label-schema.vcs-url="e.g. https://github.com/leto1210/duplicacy-web-arm"

ENV DUPLICACY_WEB_VERSION=1.6.3
ENV DUPLICACY_VERSION=2.7.2

# Set to actual USR_ID and GRP_ID of the user this should run under
# Uses root by default, unless changed

ENV USR_ID=0 \
    GRP_ID=0

ENV TZ="Europe/Paris"

# Installing software
#RUN apt-get update && apt-get install -y ca-certificates dbus tzdata wget
RUN apk --update
RUN apk add --no-cache bash
RUN apk add --no-cache ca-certificates
RUN apk add --no-cache dbus
RUN apk add --no-cache su-exec
RUN apk add --no-cache tzdata
RUN wget -nv -O /usr/local/bin/duplicacy_web https://acrosync.com/duplicacy-web/duplicacy_web_linux_arm_${DUPLICACY_WEB_VERSION} 2>&1 && \
    chmod +x /usr/local/bin/duplicacy_web && \
    rm -f /var/lib/dbus/machine-id && ln -s /config/machine-id /var/lib/dbus/machine-id && \
    wget -nv -O /usr/local/bin/duplicacy https://github.com/gilbertchen/duplicacy/releases/download/v${DUPLICACY_VERSION}/duplicacy_linux_arm_${DUPLICACY_VERSION} 2>&1 && \
    chmod +x /usr/local/bin/duplicacy

# Reduce  container size
#RUN apt-get remove wget -y && \
#    apt-get clean autoclean && \
#    apt-get autoremove -y && \
#    rm -rf /var/lib/apt/lists/* && \
#    rm -rf /tmp/*

EXPOSE 3875/tcp
VOLUME /config /logs /cache

COPY ./init.sh ./launch.sh /usr/local/bin/

ENTRYPOINT /usr/local/bin/init.sh
