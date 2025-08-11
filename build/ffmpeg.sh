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
  
  # 編碼器 - 激進禁用，只保留 libx264 和基本編碼器
  --disable-encoder=libx265,libxvid,libvpx,libvpx-vp9,libaom-av1,libtheora
  --disable-encoder=libvorbis,libopus,libmp3lame,libfdk_aac,libfaac
  --disable-encoder=wmv1,wmv2,wmv3,vc1,h263,h261,mpeg1video,mpeg2video
  --disable-encoder=flac,ape,tta,shn,ra_144,ra_288,ralf,roq_dpcm
  --disable-encoder=webp,jpeg2000,tiff,bmp,gif,pcx,tga,sgi,iff,dxv,prores
  --disable-encoder=dnxhd,prores,prores_aw,prores_ks,qtrle
  --disable-encoder=ffv1,ffvhuuff,huffyuv,utvideo,zlib
  --disable-encoder=ac3,eac3,dca,dts,truehd,mlp
  --disable-encoder=amr_nb,amr_wb,gsm,gsm_ms,ilbc
  --disable-encoder=mp2,mp3,mp3adu,mp3adufloat,mp3float
  --disable-encoder=wmav1,wmav2,wmavoice,wmapro,wmalossless
  
  # 解碼器 - 激進禁用，只保留基本解碼器
  --disable-decoder=vp8,vp9,av1,theora,wmv1,wmv2,wmv3,vc1,flv,h263,h261
  --disable-decoder=mp2,mp3float,mp3adu,mp3adufloat,wmav1,wmav2,wmavoice
  --disable-decoder=flac,ape,tta,shn,ra_144,ra_288,ralf,roq_dpcm
  --disable-decoder=webp,jpeg2000,tiff,bmp,gif,pcx,tga,sgi,iff,dxv,prores
  --disable-decoder=mpeg1video,mpeg2video,mpeg4,msmpeg4v1,msmpeg4v2,msmpeg4v3
  --disable-decoder=dnxhd,prores,prores_aw,prores_ks,qtrle
  --disable-decoder=ffv1,ffvhuuff,huffyuv,utvideo,zlib
  --disable-decoder=ac3,eac3,dca,dts,truehd,mlp
  --disable-decoder=amr_nb,amr_wb,gsm,gsm_ms,ilbc
  --disable-decoder=mp3,mp3adu,mp3adufloat,mp3float
  --disable-decoder=wmav1,wmav2,wmavoice,wmapro,wmalossless
  --disable-decoder=opus,vorbis,speex
  --disable-decoder=rv10,rv20,rv30,rv40
  --disable-decoder=indeo2,indeo3,indeo4,indeo5
  --disable-decoder=cyuv,tscc,msrle,qpeg,qtrle
  
  # Muxer - 支援常見容器
  --disable-muxers --enable-muxer=mp4,mov,avi,webm
  --disable-demuxers --enable-demuxer=mp4,mov,avi,webm
)

emconfigure ./configure "${CONF_FLAGS[@]}" $@
emmake make -j
