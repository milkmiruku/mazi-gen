FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive
ENV IMAGE_NAME mazi

RUN apt-get -y update && \
    apt-get -y install \
        git vim parted \
        quilt realpath qemu-user-static debootstrap zerofree pxz zip dosfstools \
    && rm -rf /var/lib/apt/lists/*


COPY . /pi-gen/

VOLUME [ "/pi-gen/work", "/pi-gen/deploy"]
