FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV WORKON_HOME=/root/.virtualenvs
ENV LANG=C.utf8
ENV LC_CTYPE=C.utf8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy local customization files
COPY _resources/.bashrc /root/.bashrc
COPY _resources/.vimrc /root/.vimrc
COPY _resources/packages_to_add.txt /tmp/packages_to_add.txt
COPY _resources/python_common.txt /tmp/python_common.txt
COPY _resources/inputrc /etc/inputrc

# enable non-free and contrib
RUN sed -i 's/Components: main/Components: main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources

# Install additional packages
RUN set -eux; \
    APT="apt-get -y -q --no-install-recommends -o=Dpkg::Use-Pty=0 -o=Dpkg::Options::=--force-confdef -o=Dpkg::Options::=--force-confold"; \
    $APT update; \
    $APT full-upgrade; \
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
