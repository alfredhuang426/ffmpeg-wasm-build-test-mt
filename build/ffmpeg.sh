#!/bin/bash

set -euo pipefail

CONF_FLAGS=(
  --target-os=none              # disable target specific configs
  --arch=x86_32                 # use x86_32 arch
  --enable-cross-compile        # use cross compile configs
  --disable-asm                 # disable asm
  --disable-stripping           # disable stripping as it won't work
  --disable-programs            # disable ffmpeg, ffprobe and ffplay build
  --disable-doc                 # disable doc build
  --disable-debug               # disable debug mode
  --disable-runtime-cpudetect   # disable cpu detection
  --disable-autodetect          # disable env auto detect

  # assign toolchains and extra flags
  --nm=emnm
  --ar=emar
  --ranlib=emranlib
  --cc=emcc
  --cxx=em++
  --objcc=emcc
  --dep-cc=emcc
  --extra-cflags="$CFLAGS"
  --extra-cxxflags="$CXXFLAGS"

  # disable thread when FFMPEG_ST is NOT defined
  ${FFMPEG_ST:+ --disable-pthreads --disable-w32threads --disable-os2threads}

  # First round: Remove audio codecs and unused features for video compression/transcoding
  --disable-encoders --enable-encoder=libx264
  --disable-decoders --enable-decoder=h264,hevc,mpeg4,mpeg2video,vp8,vp9
  --disable-muxers --enable-muxer=mp4,mov,avi,mkv,webm
  --disable-demuxers --enable-demuxer=mp4,mov,avi,mkv,webm,mpegvideo
  --disable-filters
  --disable-hwaccels
  --disable-parsers --enable-parser=h264,hevc,mpeg4video,mpegvideo,vp8,vp9
  --disable-protocols --enable-protocol=file
  --disable-bsfs
  --disable-indevs
  --disable-outdevs
  --disable-devices
  --disable-postproc
  --disable-swresample
  --disable-swscale
  --disable-avfilter
  --disable-avdevice
)

emconfigure ./configure "${CONF_FLAGS[@]}" $@
emmake make -j
