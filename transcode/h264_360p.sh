#!/bin/bash
# https://google.github.io/shaka-packager/html/tutorials/encoding.html
# Transcode h264_360p

VIDEOPATH=$1

DIR=$(dirname $VIDEOPATH)
FILENAME=$(basename $VIDEOPATH)
FILEBASE=${FILENAME%.*}
cd $DIR

ISWINDOWS=`uname -a | grep "CYGWIN_NT" | wc -l`
MOUNTDIR=`pwd`
if [ "$ISWINDOWS" = "1" ];then
    MOUNTDIR="$(cygpath -w $PWD)"
fi


docker run --interactive --rm -v "$MOUNTDIR"/:/media -w /media  \
    charlestg/ffmpeg_centos7 bash -s <<EOF
    
    mkdir -p ${FILENAME}.t
    
    ffmpeg -i $FILENAME \
           -c:a copy \
           -vf "scale=-2:360" \
           -c:v libx264 -profile:v baseline -level:v 3.0 \
           -x264opts scenecut=0:open_gop=0:min-keyint=72:keyint=72 \
           -minrate 600k -maxrate 600k -bufsize 600k -b:v 600k \
           -y ${FILENAME}.t/h264_baseline_360p_600.mp4
EOF

exit

ffmpeg version 2.8.15 Copyright (c) 2000-2018 the FFmpeg developers
  built with gcc 4.8.5 (GCC) 20150623 (Red Hat 4.8.5-28)
  configuration: --prefix=/usr --bindir=/usr/bin --datadir=/usr/share/ffmpeg --incdir=/usr/include/ffmpeg --libdir=/usr/lib64 --mandir=/usr/share/man --arch=x86_64 --optflags='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic' --extra-ldflags='-Wl,-z,relro ' --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvo-amrwbenc --enable-version3 --enable-bzlib --disable-crystalhd --enable-gnutls --enable-ladspa --enable-libass --enable-libcdio --enable-libdc1394 --disable-indev=jack --enable-libfreetype --enable-libgsm --enable-libmp3lame --enable-openal --enable-libopenjpeg --enable-libopus --enable-libpulse --enable-libschroedinger --enable-libsoxr --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libv4l2 --enable-libx264 --enable-libx265 --enable-libxvid --enable-x11grab --enable-avfilter --enable-avresample --enable-postproc --enable-pthreads --disable-static --enable-shared --enable-gpl --disable-debug --disable-stripping --shlibdir=/usr/lib64 --enable-runtime-cpudetect
  libavutil      54. 31.100 / 54. 31.100
  libavcodec     56. 60.100 / 56. 60.100
  libavformat    56. 40.101 / 56. 40.101
  libavdevice    56.  4.100 / 56.  4.100
  libavfilter     5. 40.101 /  5. 40.101
  libavresample   2.  1.  0 /  2.  1.  0
  libswscale      3.  1.101 /  3.  1.101
  libswresample   1.  2.101 /  1.  2.101
  libpostproc    53.  3.100 / 53.  3.100
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'big_buck_bunny_720p_30mb.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    creation_time   : 1970-01-01 00:00:00
    encoder         : Lavf53.24.2
  Duration: 00:02:50.86, start: 0.000000, bitrate: 1474 kb/s
    Stream #0:0(und): Video: h264 (Main) (avc1 / 0x31637661), yuv420p, 1280x720 [SAR 1:1 DAR 16:9], 1086 kb/s, 25 fps, 25 tbr, 12800 tbn, 50 tbc (default)
    Metadata:
      creation_time   : 1970-01-01 00:00:00
      handler_name    : VideoHandler
    Stream #0:1(und): Audio: aac (LC) (mp4a / 0x6134706D), 48000 Hz, 5.1, fltp, 383 kb/s (default)
    Metadata:
      creation_time   : 1970-01-01 00:00:00
      handler_name    : SoundHandler
[libx264 @ 0x16e4000] using SAR=1/1
[libx264 @ 0x16e4000] using cpu capabilities: MMX2 SSE2Fast SSSE3 SSE4.2
[libx264 @ 0x16e4000] profile Constrained Baseline, level 3.0
[libx264 @ 0x16e4000] 264 - core 142 r2495 6a301b6 - H.264/MPEG-4 AVC codec - Copyleft 2003-2014 - http://www.videolan.org/x264.html - options: cabac=0 ref=3 deblock=1:0:0 analyse=0x1:0x111 me=hex subme=7 psy=1 psy_rd=1.00:0.00 mixed_ref=1 me_range=16 chroma_me=1 trellis=1 8x8dct=0 cqm=0 deadzone=21,11 fast_pskip=1 chroma_qp_offset=-2 threads=6 lookahead_threads=1 sliced_threads=0 nr=0 decimate=1 interlaced=0 bluray_compat=0 constrained_intra=0 bframes=0 weightp=0 keyint=72 keyint_min=37 scenecut=0 intra_refresh=0 rc_lookahead=40 rc=cbr mbtree=1 bitrate=600 ratetol=1.0 qcomp=0.60 qpmin=0 qpmax=69 qpstep=4 vbv_maxrate=600 vbv_bufsize=600 nal_hrd=none filler=0 ip_ratio=1.40 aq=1:1.00
[mp4 @ 0x17355e0] Codec for stream 1 does not use global headers but container format requires global headers
Output #0, mp4, to 'big_buck_bunny_720p_30mb_360p_600.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    encoder         : Lavf56.40.101
    Stream #0:0(und): Video: h264 (libx264) ([33][0][0][0] / 0x0021), yuv420p, 640x360 [SAR 1:1 DAR 16:9], q=-1--1, 600 kb/s, 25 fps, 12800 tbn, 25 tbc (default)
    Metadata:
      creation_time   : 1970-01-01 00:00:00
      handler_name    : VideoHandler
      encoder         : Lavc56.60.100 libx264
    Stream #0:1(und): Audio: aac ([64][0][0][0] / 0x0040), 48000 Hz, 5.1, 383 kb/s (default)
    Metadata:
      creation_time   : 1970-01-01 00:00:00
      handler_name    : SoundHandler
Stream mapping:
  Stream #0:0 -> #0:0 (h264 (native) -> h264 (libx264))
  Stream #0:1 -> #0:1 (copy)
Press [q] to stop, [?] for help
frame=   58 fps=0.0 q=29.0 size=      52kB time=00:00:02.49 bitrate= 169.0kbits/s    
frame=   89 fps= 88 q=32.0 size=     191kB time=00:00:03.73 bitrate= 418.8kbits/s    
frame=  140 fps= 93 q=29.0 size=     475kB time=00:00:05.76 bitrate= 675.6kbits/s    
frame=  221 fps=110 q=30.0 size=     843kB time=00:00:09.00 bitrate= 767.3kbits/s    
frame=  322 fps=128 q=19.0 size=    1294kB time=00:00:13.05 bitrate= 811.8kbits/s    
frame=  404 fps=134 q=24.0 size=    1683kB time=00:00:16.32 bitrate= 844.6kbits/s    
frame=  490 fps=139 q=28.0 size=    2140kB time=00:00:19.77 bitrate= 886.3kbits/s    
frame=  563 fps=139 q=28.0 size=    2479kB time=00:00:22.69 bitrate= 894.5kbits/s    
frame=  638 fps=140 q=17.0 size=    2867kB time=00:00:25.68 bitrate= 914.2kbits/s    
frame=  717 fps=141 q=29.0 size=    3191kB time=00:00:28.84 bitrate= 906.4kbits/s    
frame=  775 fps=139 q=31.0 size=    3487kB time=00:00:31.16 bitrate= 916.5kbits/s    
frame=  813 fps=133 q=35.0 size=    3676kB time=00:00:32.68 bitrate= 921.4kbits/s    
frame=  859 fps=130 q=33.0 size=    3915kB time=00:00:34.53 bitrate= 928.6kbits/s    
frame=  920 fps=130 q=23.0 size=    4188kB time=00:00:36.97 bitrate= 927.9kbits/s    
frame= 1012 fps=133 q=21.0 size=    4613kB time=00:00:40.64 bitrate= 929.8kbits/s    
frame= 1099 fps=136 q=31.0 size=    5049kB time=00:00:44.13 bitrate= 937.1kbits/s    
frame= 1197 fps=139 q=24.0 size=    5472kB time=00:00:48.04 bitrate= 933.1kbits/s    
frame= 1328 fps=146 q=15.0 size=    6110kB time=00:00:53.29 bitrate= 939.2kbits/s    
frame= 1452 fps=151 q=23.0 size=    6684kB time=00:00:58.24 bitrate= 940.1kbits/s    
frame= 1558 fps=154 q=24.0 size=    7186kB time=00:01:02.48 bitrate= 942.1kbits/s    
frame= 1654 fps=156 q=27.0 size=    7670kB time=00:01:06.32 bitrate= 947.3kbits/s    
frame= 1737 fps=156 q=29.0 size=    8064kB time=00:01:09.65 bitrate= 948.5kbits/s    
frame= 1817 fps=156 q=32.0 size=    8450kB time=00:01:12.85 bitrate= 950.2kbits/s    
frame= 1874 fps=155 q=27.0 size=    8727kB time=00:01:15.13 bitrate= 951.5kbits/s    
frame= 1970 fps=156 q=26.0 size=    9180kB time=00:01:18.97 bitrate= 952.2kbits/s    
frame= 2049 fps=156 q=28.0 size=    9563kB time=00:01:22.13 bitrate= 953.8kbits/s    
frame= 2105 fps=155 q=26.0 size=    9825kB time=00:01:24.37 bitrate= 954.0kbits/s    
frame= 2162 fps=153 q=26.0 size=   10113kB time=00:01:26.65 bitrate= 956.0kbits/s    
frame= 2213 fps=151 q=27.0 size=   10370kB time=00:01:28.68 bitrate= 957.9kbits/s    
frame= 2286 fps=151 q=25.0 size=   10728kB time=00:01:31.60 bitrate= 959.4kbits/s    
frame= 2368 fps=151 q=28.0 size=   11122kB time=00:01:34.89 bitrate= 960.2kbits/s    
frame= 2437 fps=151 q=28.0 size=   11451kB time=00:01:37.64 bitrate= 960.7kbits/s    
frame= 2556 fps=153 q=26.0 size=   11975kB time=00:01:42.40 bitrate= 958.0kbits/s    
frame= 2665 fps=155 q=28.0 size=   12520kB time=00:01:46.77 bitrate= 960.6kbits/s    
frame= 2748 fps=156 q=25.0 size=   12902kB time=00:01:50.08 bitrate= 960.1kbits/s    
frame= 2814 fps=155 q=22.0 size=   13206kB time=00:01:52.72 bitrate= 959.7kbits/s    
frame= 2862 fps=153 q=27.0 size=   13441kB time=00:01:54.64 bitrate= 960.4kbits/s    
frame= 2913 fps=152 q=26.0 size=   13685kB time=00:01:56.69 bitrate= 960.7kbits/s    
frame= 2995 fps=152 q=24.0 size=   14059kB time=00:01:59.97 bitrate= 959.9kbits/s    
frame= 3069 fps=152 q=28.0 size=   14419kB time=00:02:02.92 bitrate= 960.9kbits/s    
frame= 3192 fps=154 q=21.0 size=   14989kB time=00:02:07.85 bitrate= 960.4kbits/s    
frame= 3294 fps=155 q=28.0 size=   15520kB time=00:02:11.92 bitrate= 963.7kbits/s    
frame= 3393 fps=156 q=32.0 size=   15983kB time=00:02:15.89 bitrate= 963.5kbits/s    
frame= 3480 fps=157 q=28.0 size=   16413kB time=00:02:19.37 bitrate= 964.7kbits/s    
frame= 3564 fps=157 q=30.0 size=   16807kB time=00:02:22.72 bitrate= 964.7kbits/s    
frame= 3663 fps=158 q=31.0 size=   17247kB time=00:02:26.68 bitrate= 963.2kbits/s    
frame= 3721 fps=157 q=29.0 size=   17536kB time=00:02:29.01 bitrate= 964.1kbits/s    
frame= 3793 fps=156 q=24.0 size=   17900kB time=00:02:31.89 bitrate= 965.4kbits/s    
frame= 3853 fps=156 q=27.0 size=   18155kB time=00:02:34.28 bitrate= 964.0kbits/s    
frame= 3914 fps=155 q=26.0 size=   18448kB time=00:02:36.73 bitrate= 964.2kbits/s    
frame= 3980 fps=155 q=18.0 size=   18761kB time=00:02:39.36 bitrate= 964.4kbits/s    
frame= 4028 fps=153 q=26.0 size=   19021kB time=00:02:41.28 bitrate= 966.1kbits/s    
frame= 4077 fps=152 q=30.0 size=   19225kB time=00:02:43.24 bitrate= 964.8kbits/s    
frame= 4123 fps=151 q=33.0 size=   19464kB time=00:02:45.09 bitrate= 965.8kbits/s    
frame= 4170 fps=150 q=34.0 size=   19692kB time=00:02:46.97 bitrate= 966.1kbits/s    
frame= 4213 fps=149 q=29.0 size=   19898kB time=00:02:48.68 bitrate= 966.3kbits/s    
frame= 4271 fps=148 q=-1.0 Lsize=   20471kB time=00:02:50.85 bitrate= 981.5kbits/s    
video:12368kB audio:8008kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.467822%
[libx264 @ 0x16e4000] frame I:60    Avg QP:17.98  size: 39497
[libx264 @ 0x16e4000] frame P:4211  Avg QP:20.96  size:  2445
[libx264 @ 0x16e4000] mb I  I16..4: 16.5%  0.0% 83.5%
[libx264 @ 0x16e4000] mb P  I16..4:  1.0%  0.0%  2.1%  P16..4: 20.3%  8.1%  3.9%  0.0%  0.0%    skip:64.7%
[libx264 @ 0x16e4000] coded y,uvDC,uvAC intra: 67.2% 88.7% 58.5% inter: 8.4% 15.1% 1.8%
[libx264 @ 0x16e4000] i16 v,h,dc,p: 22% 36% 14% 29%
[libx264 @ 0x16e4000] i4 v,h,dc,ddl,ddr,vr,hd,vl,hu: 24% 19% 15%  6%  7%  8%  7%  7%  6%
[libx264 @ 0x16e4000] i8c dc,h,v,p: 46% 27% 18%  9%
[libx264 @ 0x16e4000] ref P L0: 83.7% 10.6%  5.8%
[libx264 @ 0x16e4000] kb/s:593.04

