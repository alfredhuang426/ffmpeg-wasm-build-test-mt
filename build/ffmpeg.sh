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

  # Second stage: Conservative FFmpeg optimizations
  --disable-hwaccels
  --disable-indevs
  --disable-outdevs
  --disable-devices
  
  # 解碼器 - 只禁用一些明顯不需要的大型解碼器
  --disable-decoder=vp8,vp9,av1,theora
  --disable-decoder=flac,ape,tta,shn
  --disable-decoder=webp,jpeg2000,tiff,bmp,gif
  
  # Muxer - 支援常見容器
  --disable-muxers --enable-muxer=mp4,mov,avi,webm
  --disable-demuxers --enable-demuxer=mp4,mov,avi,webm
)

emconfigure ./configure "${CONF_FLAGS[@]}" $@
emmake make -j
