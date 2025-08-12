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
  # 激進禁用更多組件
  --disable-bsfs
  # --disable-protocols
  # 禁用特定協議（保留基本協議）
  # --disable-protocol=bluray,concat,data,ftp,gopher,hls,http,httpproxy
  # --disable-protocol=https,icecast,mmsh,mmst,pipe,rtmp,rtmpe,rtmps
  # --disable-protocol=rtmpt,rtmpte,rtmpts,rtp,srtp,tcp,tls,udp,udplite
  # 禁用特定濾鏡（保留 scale 等基本濾鏡）
  # --disable-filter=anull,aresample,asetnsamples,asetrate,asettb,atrim
  # --disable-filter=boxblur,chromakey,colorspace,convolution,crop
  # --disable-filter=deshake,drawbox,drawtext,edgedetect,fade
  # --disable-filter=fieldorder,fps,framerate,framestep,hflip
  # --disable-filter=histogram,hqdn3d,hue,idet,interlace
  # --disable-filter=kerndeint,lowpass,mp,negate,noise,overlay
  # --disable-filter=pad,pan,perspective,phase,photosensitivity
  # --disable-filter=pp,psnr,removelogo,rotate,scale_npp
  --disable-filter=select,sendcmd,setdar,setfield,setpts
  --disable-filter=setsar,settb,sharpen,showinfo,showspectrum
  --disable-filter=showvolume,shuffleframes,shuffleplanes
  --disable-filter=signalstats,silencedetect,silenceremove
  --disable-filter=split,ssim,subtitles,super2xsai,swapuv
  # --disable-filter=telecine,thumbnail,tile,transpose,unsharp
  --disable-filter=vflip,volume,volumedetect,yadif
  
  # 禁用特定解析器（保留基本解析器）
  # --disable-parser=aac,aac_latm,ac3,adx,amr,av1,avs,avs2,avs3
  --disable-parser=bmp,cavsvideo,cook,dca,dnxhd,dolby_e,dvbsub
  --disable-parser=dvd_nav,dvdsub,flac,ftr,g729,gif,gsm,h261
  # --disable-parser=h263,ipu,jpeg2000,mjpeg,mlp,mpeg4video
  --disable-parser=mpegaudio,mpegvideo,opus,png,prores,qoi,rv30
  --disable-parser=rv40,sbc,sipr,tak,vc1,vorbis,vp3,vp8,vp9
  --disable-parser=webp,xma1,xma2
  
  # 編碼器 - 極度激進禁用，只保留 libx264
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
  # --disable-encoder=aac,alac,amr_nb,amr_wb,aptx,aptx_hd
  --disable-encoder=comfortnoise,cook,dca,dsd_lsbf,dsd_lsbf_planar
  --disable-encoder=dsd_msbf,dsd_msbf_planar,eac3,evrc,flac
  --disable-encoder=g723_1,g729,gremlin,gsm,gsm_ms,ilbc
  # --disable-encoder=libcodec2,libgsm,libgsm_ms,libilbc,libmp3lame
  --disable-encoder=libopencore_amrnb,libopencore_amrwb,libopus
  --disable-encoder=libspeex,libvo_amrwbenc,libvorbis,libwavpack
  --disable-encoder=mp2,mp2fixed,mp3,mp3adu,mp3adufloat,mp3float
  --disable-encoder=nellymoser,on2avc,opus,ra_144,ra_288,ralf
  --disable-encoder=roq_dpcm,s302m,sbc,sipr,siren,sonic,sonic_ls
  --disable-encoder=speex,truehd,tta,twinvq,vorbis,wmav1,wmav2
  --disable-encoder=wmavoice,wmapro,wmalossless
  
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
  # 激進禁用更多解碼器
  # --disable-decoder=aac,aac_fixed,aac_latm,alac,amr_nb,amr_wb
  --disable-decoder=aptx,aptx_hd,comfortnoise,cook,dca,dsd_lsbf
  --disable-decoder=dsd_lsbf_planar,dsd_msbf,dsd_msbf_planar,eac3
  --disable-decoder=evrc,g723_1,g729,gremlin,gsm,gsm_ms,ilbc
  # --disable-decoder=libcodec2,libgsm,libgsm_ms,libilbc,libmp3lame
  --disable-decoder=libopencore_amrnb,libopencore_amrwb,libopus
  --disable-decoder=libspeex,libvo_amrwbdec,libvorbis,libwavpack
  --disable-decoder=mp2,mp2fixed,mp3,mp3adu,mp3adufloat,mp3float
  --disable-decoder=nellymoser,on2avc,opus,ra_144,ra_288,ralf
  --disable-decoder=roq_dpcm,s302m,sbc,sipr,siren,sonic,sonic_ls
  --disable-decoder=speex,truehd,tta,twinvq,vorbis,wmav1,wmav2
  --disable-decoder=wmavoice,wmapro,wmalossless
  
  # Muxer - 支援常見容器
  --disable-muxers --enable-muxer=mp4,mov,avi,webm
  --disable-demuxers --enable-demuxer=mp4,mov,avi,webm
)

emconfigure ./configure "${CONF_FLAGS[@]}" $@
emmake make -j
