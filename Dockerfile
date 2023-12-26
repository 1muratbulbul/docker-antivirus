FROM debian:jessie-slim

# Docker compiler
# MAINTAINER Murat BULBUL <murat.bulbul@biztek.com.tr>
LABEL org.opencontainers.image.authors="Murat BULBUL <murat.bulbul@sobeyazilim.com.tr>"
LABEL vendor="SOBE YAZILIM"
LABEL url="https://www.sobeyazilim.com.tr"
LABEL version="1.0.0"
LABEL description="DEFENDER ENGINE"
LABEL build-date="2023-12-25T12:00:00Z"

USER root

# copy assets to image
COPY ./assets /usr/local

# install antivirus and dependencies, get the latest clamav and maldet signatures
RUN apt-get update && \
    apt-get install -y apt-utils clamav clamav-daemon curl inotify-tools supervisor host tar wget chkconfig && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /var/log/cron && \
    cd /usr/local/ && chmod +x *.sh && sync && \
    cd /usr/local/bin && chmod +x *.sh && sync && \
    /usr/local/install_maldet.sh && \
    /usr/local/install_antivirus.sh && \
    apt-get -y remove curl apt-utils && \
    rm -rf /var/cache/* && \
    freshclam && \
    maldet -u -d

# export volumes (uncomment if you do not mount these volumes at runtime or via docker-compose)
# VOLUME /data/av/queue
# VOLUME /data/av/ok
# VOLUME /data/av/nok

ENTRYPOINT ["/usr/local/entrypoint.sh"]
