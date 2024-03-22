# Use Debian as the base image for the final image
FROM debian:buster-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       wget \
       perl \
       libio-socket-ssl-perl \
       libwww-perl \
       libarchive-zip-perl \
       libjson-perl \
       flac \
       lame \
       sox \
       ffmpeg \
       libcrypt-openssl-rsa-perl \
       libcrypt-openssl-random-perl \
       libcrypt-openssl-bignum-perl \
       cpanminus \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/logitechmediaserver.deb http://downloads.slimdevices.com/LogitechMediaServer_v8.0.0/logitechmediaserver_8.0.0_all.deb \
    && dpkg -i /tmp/logitechmediaserver.deb \
    && rm -f /tmp/logitechmediaserver.deb

# Create user and directories
RUN groupadd -g 9000 -r lms && \
    useradd --no-log-init -r -g lms -u 9000 lms && \
    mkdir -p /cache && \
    chown 9000 /cache

# Expose ports for Logitech Media Server
EXPOSE 3483 3483/udp 9000 9090

# Set the entrypoint for Logitech Media Server
ENTRYPOINT ["/usr/sbin/squeezeboxserver", "--prefsdir", "/mnt/prefs", "--logdir", "/mnt/logs", "--cachedir", "/cache", "--charset", "utf8"]

USER lms
