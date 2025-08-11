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
  --disable-decoder=vp8,vp9,av1,theora,wmv1,wmv2,wmv3,vc1,flv,h263,h261
  --disable-decoder=mp2,mp3float,mp3adu,mp3adufloat,wmav1,wmav2,wmavoice
  --disable-decoder=flac,ape,tta,shn,ra_144,ra_288,ralf,roq_dpcm
  --disable-decoder=webp,jpeg2000,tiff,bmp,gif,pcx,tga,sgi,iff,dxv,prores
  
  # Muxer - 支援常見容器
  --disable-muxers --enable-muxer=mp4,mov,avi,webm
  --disable-demuxers --enable-demuxer=mp4,mov,avi,webm
)

emconfigure ./configure "${CONF_FLAGS[@]}" $@
emmake make -j
