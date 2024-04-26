FROM ghcr.io/zoneminder-containers/zoneminder-base:1.36.33 AS builder
ARG NV_CODEC_VERSION='11.1.5.3'
ARG FFMPEG_VERSION='4.3.5'
ARG FFMPEG_PATH=/ffmpeg-cuda

ENV ZM_PATH_FFMPEG="${FFMPEG_PATH}/bin/ffmpeg"

WORKDIR /opt

## Install dependencies
RUN apt remove -y ffmpeg && \
    apt update && \
    apt install -y git \
                wget \
                yasm \
                cmake \
                libtool \
                libc6 \
                libc6-dev \
                unzip \
                wget \
                libnuma1 \
                libnuma-dev \
                linux-headers-amd64 \
                pkgconf && \
    ## Install nvidia codec headers
    wget https://github.com/FFmpeg/nv-codec-headers/releases/download/n${NV_CODEC_VERSION}/nv-codec-headers-${NV_CODEC_VERSION}.tar.gz -O nv-codec-headers-${NV_CODEC_VERSION}.tar.gz && \
    tar -xzf nv-codec-headers-${NV_CODEC_VERSION}.tar.gz && \
    cd nv-codec-headers-${NV_CODEC_VERSION} && \
    make && \
    make install && \
    ## Install ffmpeg
    wget https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n${FFMPEG_VERSION}.tar.gz -O ffmpeg-n${FFMPEG_VERSION}.tar.gz && \
    tar -xzf ffmpeg-n${FFMPEG_VERSION}.tar.gz && \
    cd FFmpeg-n${FFMPEG_VERSION} && \
    mkdir /ffmpeg-cuda && \
    ./configure \
        --enable-nonfree \
        --enable-cuda \
        --disable-static \
        --enable-shared \
        --disable-doc \
        --disable-htmlpages \
        --disable-manpages  \
        --disable-podpages  \
        --disable-txtpages \
        --prefix=${FFMPEG_PATH} && \
    make -j 4 && \
    make install

FROM builder AS zoneminder
ARG FFMPEG_PATH=/ffmpeg-cuda

COPY --from=builder /ffmpeg-cuda /ffmpeg-cuda

#Update lib to add ffmpeg libraries
RUN echo ${FFMPEG_PATH}/lib > /etc/ld.so.conf.d/ffmpeg.conf && \
    sed -i '/export PATH/a ldconfig' /init && \
    #Update ffmpeg paths
    mkdir -p /conf/conf.d
RUN echo ZM_PATH_FFMPEG="${FFMPEG_PATH}/bin/ffmpeg" > /conf/conf.d/99-updated-paths.conf || true

WORKDIR /