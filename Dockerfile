FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive
ENV IMAGE_NAME mazi

RUN apt-get -y update && \
    apt-get -y install \
        git vim parted \
        quilt realpath qemu-user-static debootstrap zerofree pxz zip dosfstools \
        libcap2-bin bsdtar xz-utils curl file psmisc lsof \
    && rm -rf /var/lib/apt/lists/* \
    && cd /dev \
    && mknod loop1 b 7 0 \
    && mknod loop2 b 7 0 \
    && mknod loop3 b 7 0 \
    && mknod loop4 b 7 0 \
    && mknod loop-control b 10 237


COPY . /pi-gen/

VOLUME [ "/pi-gen/work", "/pi-gen/deploy"]
