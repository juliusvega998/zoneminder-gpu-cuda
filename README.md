# Zoneminder Base with Cuda

This project is a modified docker image of [zoneminder-base docker image](https://github.com/zoneminder-containers/zoneminder-base). The only change is that ffmpeg is compiled with cuda enabled and then updated zoneminder config to use that ffmpeg.

## Disclaimer

This is just a hobby project of mine and have no plans of maintaining this. Updates might be sparse and will largely depend on me wanting to use zoneminder in the future.

## Dockerfile

### Pre-requisite

Make sure you already have docker installed with nvidia container toolkit. Here's the [guide from nvidia documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html). You will also need an nvidia graphics card with cuda capability.

### Zoneminder version

Update the first line of the Dockerfile to use whichever zoneminder version you want to use.

### Arguments
 - NV_CODEC_VERSION - the version used for ffmpeg nv_codec header. List of versions can be seen on [ffmpeg/nv-codec-headers github releases](https://github.com/FFmpeg/nv-codec-headers/releases/)
 - FFMPEG_VERSION - the ffmpeg version that will be compiled from scratch
 - FFMPEG_PATH - path where ffmpeg binaries will be stored

### Note

I was not able to confirm if compiling this image from scratch will also update the file `/conf/conf.d/99-updated-paths.conf` to use the new ZM_PATH_FFMPEG. If not you can manually edit the config file to update the ZM_PATH_FFMPEG to `${FFMPEG_PATH}/ffmpeg`.

## Docker Compose

Included `compose.example.yaml` includes how to compile and run the zoneminder with a mariadb backend server. Update the compose file and other config files (01-databases.sql and .env) to use the correct credentials.