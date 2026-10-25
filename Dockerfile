FROM debian:stable-slim

ARG DOCKER_IMAGE_VERSION=1.0
ARG PROJECT_NAME="widefrog"
ARG PROJECT_URL="https://github.com/mycodedoesnotcompile2/widefrog_docker"

LABEL \
    org.opencontainers.image.title="${PROJECT_NAME}" \
    org.opencontainers.image.description="${PROJECT_NAME} docker image" \
    org.opencontainers.image.version="${DOCKER_IMAGE_VERSION:-unknown}" \
    org.opencontainers.image.documentation="${PROJECT_URL}" \
    org.opencontainers.image.source="${PROJECT_URL}" \
    org.opencontainers.image.url="${PROJECT_URL}"

ENV DEBIAN_FRONTEND=noninteractive
ENV WORKON_HOME=/root/.virtualenvs
ENV LANG=C.utf8
ENV LC_CTYPE=C.utf8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy local customization files
COPY _resources/.bashrc /root/.bashrc
COPY _resources/.vimrc /root/.vimrc
COPY _resources/.inputrc /etc/inputrc
COPY _resources/packages_to_add.txt /tmp/packages_to_add.txt
COPY _resources/setup.sh /tmp/setup.sh

# enable non-free and contrib
RUN sed -i 's/Components: main/Components: main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources

# Install additional packages
RUN set -eux; \
    APT="apt-get -y -q --no-install-recommends -o=Dpkg::Use-Pty=0 -o=Dpkg::Options::=--force-confdef -o=Dpkg::Options::=--force-confold"; \
    $APT update; \
    
    $APT install ca-certificates gpgv wget; \
    $APT full-upgrade; \
    . /etc/os-release; \
    
    wget -q "https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2024.9.1_all.deb" -O "/tmp/deb-multimedia-keyring.deb"; \
    dpkg -i "/tmp/deb-multimedia-keyring.deb"; \
    printf 'Types: deb\nURIs: https://www.deb-multimedia.org\nSuites: %s\nComponents: main non-free\nSigned-By: /usr/share/keyrings/deb-multimedia-keyring.pgp\n' \
        "$VERSION_CODENAME" > /etc/apt/sources.list.d/deb-multimedia.sources; \
    
    $APT update; \
    $APT install $(cat /tmp/packages_to_add.txt); \
    rm -f /tmp/packages_to_add.txt; \
    $APT purge 'exim4*' 'bsd-mailx*'; \
    $APT autoremove --purge; \
    $APT autoclean; \
    $APT clean; \
    rm -rf /var/lib/apt/lists/*


RUN dpkg-query -W -f='${Installed-Size}\t${Package}\t${Version}\n' \
    | sort -nr \
    | column -t
    
RUN chmod +x /tmp/setup.sh && /tmp/setup.sh

RUN set -eux; \
    SERVICES_TO_DISABLE="\
    rpcbind.socket \
    rpcbind \
    rpcbind.service \
    rpc-statd-notify.service \
    xrdp \
    systemd-resolved.service \
    lvm2-monitor.service \
    mdadm-shutdown.service \
    tor.service \
    lvm2-lvmpolld.socket \
    nfs-client.target \
    remote-fs.target \
    exim4.service \
    exim4-base.timer \
    fstrim.timer \
    lm-sensors.service \
    tftpd-hpa.service \
    pmcd.service \
    pmie.service \
    pmproxy.service \
    stunnel.target \
    apt-daily-upgrade.timer \
    apt-daily.timer \
    e2scrub_all.timer \
    dpkg-db-backup.timer \
    mdcheck_continue.timer \
    mdcheck_start.timer \
    mdmonitor-oneshot.timer \
    nvmf-autoconnect.service \
    nvmefc-boot-connections.service \
    openvpn.service \
    pmlogger.service \
    system-bcachefsck.slice \
    system-xfs_scrub.slice \
    iscsid.socket \
    dm-event.socket \
    bcachefsck_all.timer \
    xfs_scrub_all.timer \
    atop-rotate.timer \
    atopacct.service \
    atop.service \
    multipathd.service \
    pcscd.socket \
    tpm-dev.path \
    tpm-udev.path \
    hardinfo2.service \
    atd.service"; \
    \
    for service in ${SERVICES_TO_DISABLE}; do \
        ln -sf /dev/null "/etc/systemd/system/${service}"; \
    done

# Final cleanup
RUN apt-get clean && \
    rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /tmp/* \
        /var/tmp/* \
        /var/log/* \
        /root/.cache

CMD ["/bin/bash"]
