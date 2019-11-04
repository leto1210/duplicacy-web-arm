FROM arm32v7/alpine:latest

ENV DUPLICACY_WEB_VERSION=1.1.0

# Set to actual USR_ID and GRP_ID of the user this should run under
# Uses root by default, unless changed

ENV USR_ID=0 \
    GRP_ID=0

ENV TZ="Europe/Paris"

# Installing software
RUN apk --update add --no-cache bash ca-certificates dbus  su-exec tzdata                         && \
    wget -nv -O /usr/local/bin/duplicacy_web                                           \
        https://acrosync.com/duplicacy-web/duplicacy_web_linux_arm_${DUPLICACY_WEB_VERSION} 2>&1  && \
    chmod +x /usr/local/bin/duplicacy_web                                                         && \
    mkdir -p /root/.duplicacy-web/bin                                                             && \
    chmod 777 /root/.duplicacy-web/bin                                                            && \
    rm -f /var/lib/dbus/machine-id && ln -s /config/machine-id /var/lib/dbus/machine-id           && \
    chmod 774 /root/.duplicacy-web/bin/duplicacy                                                  && \
    chmod 774 /root/.duplicacy-web/bin/duplicacy_web

EXPOSE 3875/tcp
VOLUME /config /logs /cache

COPY ./init.sh ./launch.sh /usr/local/bin/

ENTRYPOINT /usr/local/bin/init.sh
