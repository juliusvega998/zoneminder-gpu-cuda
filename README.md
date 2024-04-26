# Zoneminder Base with Cuda

This is a modified docker image of [zoneminder-base docker image](https://github.com/zoneminder-containers/zoneminder-base). The only change is that ffmpeg is compiled with cuda enabled and then updated zoneminder config.

## Disclaimer

This is just a hobby project of mine and have no plans of maintaining this. Updates might be sparse and will largely depend on me wanting to use zoneminder in the future.

## Dockerfile

### Pre-requisite

Make sure you already have docker installed with nvidia container toolkit. Here's [nvidia documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) if you haven't installed it yet.
You will also need an nvidia graphics card. A more recently released GPU is preferrable but it does not necessarily need a strong one. I use a GTX 1660 Super with 4 cameras and it is heavily under-utilized.

### Zoneminder version

Update the first line of the Dockerfile to use whichever zoneminder version you want to use.

### Arguments
The following new arguments are added:
 - `NV_CODEC_VERSION` - the version used for ffmpeg nv_codec header. List of versions can be seen on [ffmpeg/nv-codec-headers github releases](https://github.com/FFmpeg/nv-codec-headers/releases/)
 - `FFMPEG_VERSION` - the ffmpeg version that will be compiled from scratch
 - `FFMPEG_PATH` - path where ffmpeg binaries will be stored

This might also support the arguments in [zoneminder-base](https://github.com/zoneminder-containers/zoneminder-base) but I haven't tested it yet.

### Note

I was not able to confirm if compiling this image from scratch will also update the file `/conf/conf.d/99-updated-paths.conf` to use the new ZM_PATH_FFMPEG. If not you can manually edit the config file to update the ZM_PATH_FFMPEG to `${FFMPEG_PATH}/ffmpeg`.

## Docker Compose

Included `compose.example.yaml` shows how to setup a zoneminder with a mariadb server. Create a copy of the compose file `compose.example.yaml` and other config files (`01-databases.sql` and `.env`) to use the correct db credentials.
