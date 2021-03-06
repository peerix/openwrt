FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y sudo time git-core subversion build-essential gcc-multilib ncurses-base \
                       libncurses5-dev zlib1g-dev gawk flex gettext wget curl unzip python && \
    apt-get clean

RUN useradd -m openwrt &&\
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

USER openwrt
WORKDIR /home/openwrt

ENV OPENWRT_VERSION=19.07.3
RUN wget -O - https://github.com/openwrt/openwrt/archive/v${OPENWRT_VERSION}.tar.gz | \
  tar --strip=1 -xzvf - && \
  scripts/feeds update -a


COPY --chown=openwrt:openwrt config .config
RUN make defconfig

ENV PACKAGES=""

USER root
