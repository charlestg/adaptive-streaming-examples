#!/bin/bash
# https://google.github.io/shaka-packager/html/tutorials/encoding.html
# Transcode h264_1080p

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
    
    ffmpeg -i $FILENAME -c:a copy \
       -vf "scale=-2:1080" \
       -c:v libx264 -profile:v high -level:v 4.2 \
       -x264opts scenecut=0:open_gop=0:min-keyint=72:keyint=72 \
       -minrate 6000k -maxrate 6000k -bufsize 6000k -b:v 6000k \
       -y ${FILENAME}.t/h264_high_1080p_6000.mp4
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
[libx264 @ 0x21f3000] using SAR=1/1
[libx264 @ 0x21f3000] using cpu capabilities: MMX2 SSE2Fast SSSE3 SSE4.2
[libx264 @ 0x21f3000] profile High, level 4.2
[libx264 @ 0x21f3000] 264 - core 142 r2495 6a301b6 - H.264/MPEG-4 AVC codec - Copyleft 2003-2014 - http://www.videolan.org/x264.html - options: cabac=1 ref=3 deblock=1:0:0 analyse=0x3:0x113 me=hex subme=7 psy=1 psy_rd=1.00:0.00 mixed_ref=1 me_range=16 chroma_me=1 trellis=1 8x8dct=1 cqm=0 deadzone=21,11 fast_pskip=1 chroma_qp_offset=-2 threads=6 lookahead_threads=1 sliced_threads=0 nr=0 decimate=1 interlaced=0 bluray_compat=0 constrained_intra=0 bframes=3 b_pyramid=2 b_adapt=1 b_bias=0 direct=1 weightb=1 open_gop=0 weightp=2 keyint=72 keyint_min=37 scenecut=0 intra_refresh=0 rc_lookahead=40 rc=cbr mbtree=1 bitrate=6000 ratetol=1.0 qcomp=0.60 qpmin=0 qpmax=69 qpstep=4 vbv_maxrate=6000 vbv_bufsize=6000 nal_hrd=none filler=0 ip_ratio=1.40 aq=1:1.00
[mp4 @ 0x22445e0] Codec for stream 1 does not use global headers but container format requires global headers
Output #0, mp4, to 'big_buck_bunny_720p_30mb_1080p_6000.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    encoder         : Lavf56.40.101
    Stream #0:0(und): Video: h264 (libx264) ([33][0][0][0] / 0x0021), yuv420p, 1920x1080 [SAR 1:1 DAR 16:9], q=-1--1, 6000 kb/s, 25 fps, 12800 tbn, 25 tbc (default)
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
frame=   46 fps=0.0 q=0.0 size=       0kB time=00:00:02.00 bitrate=   0.2kbits/s    
frame=   53 fps= 35 q=33.0 size=     163kB time=00:00:02.28 bitrate= 584.7kbits/s    
frame=   64 fps= 30 q=25.0 size=     305kB time=00:00:02.73 bitrate= 915.5kbits/s    
frame=   74 fps= 28 q=25.0 size=     532kB time=00:00:03.13 bitrate=1390.3kbits/s    
frame=   84 fps= 26 q=26.0 size=     811kB time=00:00:03.52 bitrate=1887.1kbits/s    
frame=   93 fps= 25 q=26.0 size=    1051kB time=00:00:03.88 bitrate=2217.2kbits/s    
frame=   99 fps= 23 q=26.0 size=    1281kB time=00:00:04.13 bitrate=2535.2kbits/s    
frame=  105 fps= 22 q=25.0 size=    1415kB time=00:00:04.37 bitrate=2649.9kbits/s    
frame=  114 fps= 21 q=24.0 size=    1690kB time=00:00:04.73 bitrate=2923.2kbits/s    
frame=  124 fps= 21 q=24.0 size=    2195kB time=00:00:05.12 bitrate=3512.4kbits/s    
frame=  136 fps= 21 q=22.0 size=    2511kB time=00:00:05.61 bitrate=3666.7kbits/s    
frame=  149 fps= 22 q=21.0 size=    2754kB time=00:00:06.12 bitrate=3685.2kbits/s    
frame=  161 fps= 22 q=23.0 size=    3049kB time=00:00:06.61 bitrate=3776.8kbits/s    
frame=  169 fps= 21 q=22.0 size=    3222kB time=00:00:06.93 bitrate=3806.3kbits/s    
frame=  178 fps= 21 q=22.0 size=    3414kB time=00:00:07.29 bitrate=3833.5kbits/s    
frame=  186 fps= 21 q=23.0 size=    3606kB time=00:00:07.61 bitrate=3878.8kbits/s    
frame=  196 fps= 21 q=24.0 size=    4189kB time=00:00:08.00 bitrate=4289.4kbits/s    
frame=  208 fps= 21 q=23.0 size=    4365kB time=00:00:08.49 bitrate=4211.0kbits/s    
frame=  217 fps= 20 q=23.0 size=    4633kB time=00:00:08.85 bitrate=4287.1kbits/s    
frame=  229 fps= 20 q=22.0 size=    4990kB time=00:00:09.32 bitrate=4384.7kbits/s    
frame=  237 fps= 20 q=21.0 size=    5181kB time=00:00:09.64 bitrate=4401.7kbits/s    
frame=  243 fps= 20 q=18.0 size=    5451kB time=00:00:09.89 bitrate=4511.1kbits/s    
frame=  253 fps= 20 q=17.0 size=    5825kB time=00:00:10.28 bitrate=4640.6kbits/s    
frame=  267 fps= 20 q=15.0 size=    6453kB time=00:00:10.85 bitrate=4868.6kbits/s    
frame=  287 fps= 20 q=5.0 size=    6575kB time=00:00:11.64 bitrate=4624.5kbits/s    
frame=  306 fps= 21 q=13.0 size=    7010kB time=00:00:12.41 bitrate=4625.1kbits/s    
frame=  319 fps= 21 q=14.0 size=    7338kB time=00:00:12.92 bitrate=4649.6kbits/s    
frame=  330 fps= 21 q=13.0 size=    7639kB time=00:00:13.37 bitrate=4678.7kbits/s    
frame=  342 fps= 21 q=16.0 size=    8207kB time=00:00:13.84 bitrate=4855.9kbits/s    
frame=  357 fps= 21 q=14.0 size=    8412kB time=00:00:14.44 bitrate=4771.1kbits/s    
frame=  371 fps= 22 q=17.0 size=    8653kB time=00:00:15.01 bitrate=4719.7kbits/s    
frame=  378 fps= 21 q=16.0 size=    8980kB time=00:00:15.29 bitrate=4809.4kbits/s    
frame=  385 fps= 21 q=17.0 size=    9210kB time=00:00:15.57 bitrate=4844.5kbits/s    
frame=  394 fps= 21 q=17.0 size=    9480kB time=00:00:15.93 bitrate=4873.3kbits/s    
frame=  404 fps= 21 q=15.0 size=    9763kB time=00:00:16.32 bitrate=4900.6kbits/s    
frame=  413 fps= 21 q=17.0 size=   10234kB time=00:00:16.68 bitrate=5025.4kbits/s    
frame=  421 fps= 21 q=18.0 size=   10365kB time=00:00:17.00 bitrate=4994.0kbits/s    
frame=  429 fps= 20 q=17.0 size=   10577kB time=00:00:17.32 bitrate=5001.9kbits/s    
frame=  438 fps= 20 q=18.0 size=   10825kB time=00:00:17.68 bitrate=5014.2kbits/s    
frame=  445 fps= 20 q=19.0 size=   11014kB time=00:00:17.96 bitrate=5022.9kbits/s    
frame=  453 fps= 20 q=17.0 size=   11517kB time=00:00:18.28 bitrate=5160.4kbits/s    
frame=  467 fps= 20 q=18.0 size=   11707kB time=00:00:18.85 bitrate=5085.3kbits/s    
frame=  474 fps= 20 q=17.0 size=   11840kB time=00:00:19.13 bitrate=5068.8kbits/s    
frame=  483 fps= 20 q=21.0 size=   12438kB time=00:00:19.49 bitrate=5225.5kbits/s    
frame=  491 fps= 20 q=21.0 size=   12614kB time=00:00:19.81 bitrate=5213.9kbits/s    
frame=  499 fps= 20 q=20.0 size=   12804kB time=00:00:20.13 bitrate=5208.5kbits/s    
frame=  510 fps= 20 q=21.0 size=   13071kB time=00:00:20.56 bitrate=5206.8kbits/s    
frame=  519 fps= 19 q=21.0 size=   13326kB time=00:00:20.92 bitrate=5216.3kbits/s    
frame=  529 fps= 19 q=21.0 size=   13680kB time=00:00:21.33 bitrate=5252.9kbits/s    
frame=  537 fps= 19 q=21.0 size=   13937kB time=00:00:21.65 bitrate=5272.7kbits/s    
frame=  544 fps= 19 q=22.0 size=   14196kB time=00:00:21.93 bitrate=5302.7kbits/s    
frame=  550 fps= 19 q=21.0 size=   14427kB time=00:00:22.16 bitrate=5332.1kbits/s    
frame=  558 fps= 19 q=22.0 size=   14683kB time=00:00:22.48 bitrate=5349.4kbits/s    
frame=  566 fps= 19 q=21.0 size=   14908kB time=00:00:22.80 bitrate=5355.0kbits/s    
frame=  576 fps= 19 q=21.0 size=   15184kB time=00:00:23.21 bitrate=5359.2kbits/s    
frame=  585 fps= 19 q=21.0 size=   15578kB time=00:00:23.57 bitrate=5413.4kbits/s    
frame=  594 fps= 19 q=19.0 size=   16057kB time=00:00:23.93 bitrate=5495.5kbits/s    
frame=  610 fps= 19 q=18.0 size=   16198kB time=00:00:24.57 bitrate=5399.2kbits/s    
frame=  621 fps= 19 q=14.0 size=   16315kB time=00:00:25.00 bitrate=5345.5kbits/s    
frame=  633 fps= 19 q=18.0 size=   16748kB time=00:00:25.49 bitrate=5381.9kbits/s    
frame=  641 fps= 19 q=14.0 size=   17231kB time=00:00:25.81 bitrate=5468.2kbits/s    
frame=  658 fps= 19 q=16.0 size=   17498kB time=00:00:26.49 bitrate=5409.9kbits/s    
frame=  667 fps= 19 q=16.0 size=   17685kB time=00:00:26.85 bitrate=5393.9kbits/s    
frame=  675 fps= 19 q=16.0 size=   17881kB time=00:00:27.17 bitrate=5389.5kbits/s    
frame=  686 fps= 19 q=13.0 size=   18139kB time=00:00:27.60 bitrate=5382.8kbits/s    
frame=  695 fps= 19 q=24.0 size=   18327kB time=00:00:27.96 bitrate=5368.2kbits/s    
frame=  705 fps= 19 q=22.0 size=   18670kB time=00:00:28.37 bitrate=5390.3kbits/s    
frame=  712 fps= 19 q=22.0 size=   18803kB time=00:00:28.65 bitrate=5376.2kbits/s    
frame=  718 fps= 19 q=23.0 size=   18958kB time=00:00:28.88 bitrate=5376.5kbits/s    
frame=  724 fps= 18 q=24.0 size=   19183kB time=00:00:29.12 bitrate=5396.5kbits/s    
frame=  734 fps= 19 q=25.0 size=   19484kB time=00:00:29.52 bitrate=5406.1kbits/s    
frame=  742 fps= 18 q=26.0 size=   19686kB time=00:00:29.84 bitrate=5403.5kbits/s    
frame=  747 fps= 18 q=26.0 size=   19935kB time=00:00:30.05 bitrate=5433.0kbits/s    
frame=  755 fps= 18 q=27.0 size=   20166kB time=00:00:30.37 bitrate=5438.1kbits/s    
frame=  763 fps= 18 q=16.0 size=   20351kB time=00:00:30.69 bitrate=5430.7kbits/s    
frame=  768 fps= 18 q=27.0 size=   20537kB time=00:00:30.89 bitrate=5446.4kbits/s    
frame=  778 fps= 18 q=27.0 size=   20959kB time=00:00:31.29 bitrate=5486.1kbits/s    
frame=  787 fps= 18 q=27.0 size=   21275kB time=00:00:31.65 bitrate=5505.0kbits/s    
frame=  794 fps= 18 q=27.0 size=   21509kB time=00:00:31.93 bitrate=5517.2kbits/s    
frame=  802 fps= 18 q=27.0 size=   21776kB time=00:00:32.25 bitrate=5530.3kbits/s    
frame=  809 fps= 18 q=27.0 size=   21973kB time=00:00:32.53 bitrate=5532.8kbits/s    
frame=  815 fps= 18 q=28.0 size=   22155kB time=00:00:32.76 bitrate=5538.8kbits/s    
frame=  823 fps= 18 q=26.0 size=   22358kB time=00:00:33.08 bitrate=5535.4kbits/s    
frame=  830 fps= 18 q=25.0 size=   22620kB time=00:00:33.36 bitrate=5553.8kbits/s    
frame=  837 fps= 18 q=25.0 size=   22843kB time=00:00:33.64 bitrate=5562.2kbits/s    
frame=  847 fps= 18 q=25.0 size=   23316kB time=00:00:34.04 bitrate=5609.9kbits/s    
frame=  856 fps= 18 q=26.0 size=   23579kB time=00:00:34.41 bitrate=5613.3kbits/s    
frame=  863 fps= 17 q=23.0 size=   23741kB time=00:00:34.68 bitrate=5606.8kbits/s    
frame=  867 fps= 17 q=23.0 size=   23809kB time=00:00:34.85 bitrate=5595.4kbits/s    
frame=  874 fps= 17 q=23.0 size=   23972kB time=00:00:35.13 bitrate=5589.2kbits/s    
frame=  885 fps= 17 q=23.0 size=   24263kB time=00:00:35.56 bitrate=5589.1kbits/s    
frame=  893 fps= 17 q=23.0 size=   24445kB time=00:00:35.88 bitrate=5580.8kbits/s    
frame=  904 fps= 17 q=23.0 size=   24692kB time=00:00:36.33 bitrate=5567.6kbits/s    
frame=  912 fps= 17 q=22.0 size=   24870kB time=00:00:36.65 bitrate=5558.9kbits/s    
frame=  921 fps= 17 q=21.0 size=   25308kB time=00:00:37.01 bitrate=5601.3kbits/s    
frame=  929 fps= 17 q=20.0 size=   25590kB time=00:00:37.33 bitrate=5615.2kbits/s    
frame=  937 fps= 17 q=18.0 size=   25851kB time=00:00:37.65 bitrate=5624.1kbits/s    
frame=  954 fps= 17 q=14.0 size=   26353kB time=00:00:38.33 bitrate=5631.3kbits/s    
frame=  966 fps= 17 q=14.0 size=   26670kB time=00:00:38.80 bitrate=5630.1kbits/s    
frame=  980 fps= 18 q=14.0 size=   26905kB time=00:00:39.36 bitrate=5599.8kbits/s    
frame=  993 fps= 18 q=18.0 size=   27549kB time=00:00:39.89 bitrate=5657.2kbits/s    
frame= 1007 fps= 18 q=13.0 size=   27797kB time=00:00:40.44 bitrate=5629.7kbits/s    
frame= 1021 fps= 18 q=15.0 size=   28089kB time=00:00:41.00 bitrate=5611.9kbits/s    
frame= 1032 fps= 18 q=14.0 size=   28353kB time=00:00:41.45 bitrate=5603.4kbits/s    
frame= 1042 fps= 18 q=13.0 size=   28584kB time=00:00:41.85 bitrate=5594.3kbits/s    
frame= 1051 fps= 18 q=14.0 size=   28907kB time=00:00:42.21 bitrate=5609.0kbits/s    
frame= 1065 fps= 18 q=14.0 size=   29623kB time=00:00:42.77 bitrate=5673.4kbits/s    
frame= 1080 fps= 18 q=11.0 size=   29786kB time=00:00:43.37 bitrate=5626.0kbits/s    
frame= 1097 fps= 18 q=19.0 size=   30102kB time=00:00:44.05 bitrate=5597.7kbits/s    
frame= 1103 fps= 18 q=20.0 size=   30483kB time=00:00:44.28 bitrate=5638.4kbits/s    
frame= 1115 fps= 18 q=19.0 size=   30679kB time=00:00:44.77 bitrate=5612.6kbits/s    
frame= 1125 fps= 18 q=18.0 size=   30989kB time=00:00:45.16 bitrate=5621.0kbits/s    
frame= 1139 fps= 18 q=15.0 size=   31644kB time=00:00:45.73 bitrate=5667.5kbits/s    
frame= 1148 fps= 18 q=12.0 size=   32075kB time=00:00:46.08 bitrate=5702.3kbits/s    
frame= 1159 fps= 18 q=12.0 size=   32275kB time=00:00:46.52 bitrate=5682.6kbits/s    
frame= 1179 fps= 18 q=12.0 size=   32592kB time=00:00:47.33 bitrate=5640.1kbits/s    
frame= 1194 fps= 18 q=13.0 size=   32988kB time=00:00:47.93 bitrate=5637.4kbits/s    
frame= 1214 fps= 19 q=11.0 size=   33687kB time=00:00:48.72 bitrate=5663.7kbits/s    
frame= 1231 fps= 19 q=15.0 size=   34026kB time=00:00:49.40 bitrate=5641.6kbits/s    
frame= 1245 fps= 19 q=15.0 size=   34363kB time=00:00:49.96 bitrate=5634.3kbits/s    
frame= 1256 fps= 19 q=15.0 size=   34697kB time=00:00:50.41 bitrate=5638.4kbits/s    
frame= 1265 fps= 19 q=14.0 size=   34975kB time=00:00:50.77 bitrate=5643.0kbits/s    
frame= 1280 fps= 19 q=14.0 size=   35876kB time=00:00:51.37 bitrate=5721.1kbits/s    
frame= 1295 fps= 19 q=11.0 size=   36207kB time=00:00:51.96 bitrate=5707.4kbits/s    
frame= 1309 fps= 19 q=12.0 size=   36530kB time=00:00:52.52 bitrate=5697.6kbits/s    
frame= 1325 fps= 19 q=9.0 size=   36789kB time=00:00:53.16 bitrate=5669.0kbits/s    
frame= 1340 fps= 19 q=7.0 size=   37015kB time=00:00:53.76 bitrate=5640.4kbits/s    
frame= 1352 fps= 19 q=14.0 size=   37808kB time=00:00:54.25 bitrate=5709.2kbits/s    
frame= 1365 fps= 19 q=19.0 size=   38034kB time=00:00:54.76 bitrate=5689.6kbits/s    
frame= 1378 fps= 19 q=20.0 size=   38303kB time=00:00:55.29 bitrate=5674.4kbits/s    
frame= 1392 fps= 19 q=20.0 size=   38553kB time=00:00:55.85 bitrate=5654.9kbits/s    
frame= 1402 fps= 19 q=19.0 size=   38856kB time=00:00:56.25 bitrate=5658.2kbits/s    
frame= 1411 fps= 19 q=19.0 size=   39464kB time=00:00:56.61 bitrate=5709.9kbits/s    
frame= 1428 fps= 19 q=20.0 size=   40079kB time=00:00:57.28 bitrate=5732.0kbits/s    
frame= 1441 fps= 19 q=20.0 size=   40242kB time=00:00:57.81 bitrate=5702.1kbits/s    
frame= 1455 fps= 19 q=18.0 size=   40364kB time=00:00:58.36 bitrate=5665.1kbits/s    
frame= 1459 fps= 19 q=18.0 size=   40584kB time=00:00:58.53 bitrate=5679.4kbits/s    
frame= 1471 fps= 19 q=18.0 size=   40861kB time=00:00:59.00 bitrate=5672.6kbits/s    
frame= 1486 fps= 19 q=15.0 size=   41240kB time=00:00:59.60 bitrate=5667.9kbits/s    
frame= 1498 fps= 19 q=18.0 size=   41781kB time=00:01:00.09 bitrate=5695.3kbits/s    
frame= 1512 fps= 19 q=18.0 size=   42283kB time=00:01:00.65 bitrate=5711.0kbits/s    
frame= 1519 fps= 19 q=17.0 size=   42494kB time=00:01:00.92 bitrate=5713.5kbits/s    
frame= 1526 fps= 19 q=17.0 size=   42635kB time=00:01:01.20 bitrate=5706.4kbits/s    
frame= 1539 fps= 19 q=18.0 size=   42949kB time=00:01:01.73 bitrate=5698.8kbits/s    
frame= 1549 fps= 19 q=16.0 size=   43156kB time=00:01:02.12 bitrate=5690.9kbits/s    
frame= 1563 fps= 19 q=17.0 size=   43845kB time=00:01:02.69 bitrate=5728.6kbits/s    
frame= 1577 fps= 19 q=18.0 size=   44271kB time=00:01:03.25 bitrate=5733.6kbits/s    
frame= 1594 fps= 20 q=17.0 size=   44659kB time=00:01:03.93 bitrate=5722.0kbits/s    
frame= 1607 fps= 20 q=17.0 size=   45005kB time=00:01:04.44 bitrate=5720.6kbits/s    
frame= 1618 fps= 20 q=17.0 size=   45319kB time=00:01:04.89 bitrate=5720.7kbits/s    
frame= 1626 fps= 20 q=14.0 size=   45506kB time=00:01:05.21 bitrate=5716.1kbits/s    
frame= 1639 fps= 20 q=18.0 size=   46025kB time=00:01:05.72 bitrate=5736.4kbits/s    
frame= 1649 fps= 20 q=20.0 size=   46316kB time=00:01:06.13 bitrate=5737.2kbits/s    
frame= 1664 fps= 20 q=22.0 size=   46649kB time=00:01:06.73 bitrate=5726.8kbits/s    
frame= 1675 fps= 20 q=23.0 size=   47143kB time=00:01:07.17 bitrate=5748.8kbits/s    
frame= 1683 fps= 20 q=22.0 size=   47384kB time=00:01:07.49 bitrate=5750.8kbits/s    
frame= 1688 fps= 19 q=23.0 size=   47565kB time=00:01:07.69 bitrate=5756.4kbits/s    
frame= 1696 fps= 19 q=23.0 size=   47756kB time=00:01:08.01 bitrate=5752.3kbits/s    
frame= 1712 fps= 20 q=18.0 size=   48458kB time=00:01:08.65 bitrate=5782.5kbits/s    
frame= 1728 fps= 20 q=18.0 size=   48709kB time=00:01:09.29 bitrate=5758.7kbits/s    
frame= 1745 fps= 20 q=19.0 size=   49018kB time=00:01:09.97 bitrate=5738.7kbits/s    
frame= 1757 fps= 20 q=20.0 size=   49345kB time=00:01:10.44 bitrate=5738.5kbits/s    
frame= 1765 fps= 20 q=19.0 size=   49577kB time=00:01:10.76 bitrate=5739.4kbits/s    
frame= 1774 fps= 20 q=18.0 size=   49806kB time=00:01:11.12 bitrate=5736.5kbits/s    
frame= 1784 fps= 20 q=22.0 size=   50421kB time=00:01:11.53 bitrate=5774.5kbits/s    
frame= 1795 fps= 20 q=22.0 size=   50626kB time=00:01:11.97 bitrate=5761.9kbits/s    
frame= 1803 fps= 20 q=22.0 size=   50726kB time=00:01:12.29 bitrate=5747.6kbits/s    
frame= 1811 fps= 20 q=23.0 size=   50986kB time=00:01:12.61 bitrate=5751.7kbits/s    
frame= 1817 fps= 19 q=23.0 size=   51196kB time=00:01:12.85 bitrate=5756.8kbits/s    
frame= 1826 fps= 19 q=24.0 size=   51540kB time=00:01:13.21 bitrate=5766.7kbits/s    
frame= 1836 fps= 19 q=24.0 size=   51797kB time=00:01:13.60 bitrate=5765.2kbits/s    
frame= 1843 fps= 19 q=24.0 size=   52113kB time=00:01:13.89 bitrate=5777.0kbits/s    
frame= 1848 fps= 19 q=32.0 size=   52352kB time=00:01:14.09 bitrate=5788.4kbits/s    
frame= 1860 fps= 19 q=22.0 size=   52672kB time=00:01:14.56 bitrate=5787.1kbits/s    
frame= 1868 fps= 19 q=22.0 size=   52829kB time=00:01:14.88 bitrate=5779.6kbits/s    
frame= 1880 fps= 19 q=22.0 size=   53159kB time=00:01:15.37 bitrate=5777.8kbits/s    
frame= 1893 fps= 19 q=21.0 size=   53497kB time=00:01:15.88 bitrate=5775.3kbits/s    
frame= 1902 fps= 19 q=21.0 size=   53828kB time=00:01:16.24 bitrate=5783.4kbits/s    
frame= 1914 fps= 19 q=22.0 size=   54116kB time=00:01:16.73 bitrate=5777.2kbits/s    
frame= 1927 fps= 19 q=21.0 size=   54630kB time=00:01:17.24 bitrate=5793.4kbits/s    
frame= 1936 fps= 19 q=20.0 size=   54839kB time=00:01:17.61 bitrate=5788.4kbits/s    
frame= 1945 fps= 19 q=19.0 size=   55198kB time=00:01:17.97 bitrate=5799.2kbits/s    
frame= 1957 fps= 19 q=18.0 size=   55447kB time=00:01:18.44 bitrate=5790.5kbits/s    
frame= 1967 fps= 19 q=18.0 size=   55700kB time=00:01:18.84 bitrate=5787.0kbits/s    
frame= 1978 fps= 19 q=19.0 size=   56018kB time=00:01:19.29 bitrate=5787.2kbits/s    
frame= 1990 fps= 19 q=18.0 size=   56244kB time=00:01:19.76 bitrate=5776.3kbits/s    
frame= 2001 fps= 19 q=20.0 size=   56778kB time=00:01:20.21 bitrate=5798.6kbits/s    
frame= 2012 fps= 19 q=20.0 size=   56956kB time=00:01:20.64 bitrate=5786.0kbits/s    
frame= 2020 fps= 19 q=19.0 size=   57142kB time=00:01:20.96 bitrate=5782.0kbits/s    
frame= 2030 fps= 19 q=20.0 size=   57540kB time=00:01:21.36 bitrate=5793.2kbits/s    
frame= 2044 fps= 19 q=20.0 size=   57928kB time=00:01:21.92 bitrate=5792.8kbits/s    
frame= 2055 fps= 19 q=20.0 size=   58312kB time=00:01:22.36 bitrate=5799.5kbits/s    
frame= 2069 fps= 19 q=20.0 size=   59044kB time=00:01:22.92 bitrate=5833.0kbits/s    
frame= 2083 fps= 19 q=18.0 size=   59298kB time=00:01:23.49 bitrate=5817.7kbits/s    
frame= 2093 fps= 19 q=17.0 size=   59511kB time=00:01:23.88 bitrate=5811.8kbits/s    
frame= 2102 fps= 19 q=20.0 size=   59721kB time=00:01:24.24 bitrate=5807.3kbits/s    
frame= 2116 fps= 19 q=19.0 size=   59893kB time=00:01:24.80 bitrate=5785.9kbits/s    
frame= 2129 fps= 19 q=19.0 size=   60250kB time=00:01:25.33 bitrate=5784.0kbits/s    
frame= 2141 fps= 19 q=20.0 size=   60954kB time=00:01:25.80 bitrate=5819.6kbits/s    
frame= 2154 fps= 19 q=19.0 size=   61204kB time=00:01:26.33 bitrate=5807.4kbits/s    
frame= 2166 fps= 19 q=20.0 size=   61590kB time=00:01:26.80 bitrate=5812.4kbits/s    
frame= 2178 fps= 20 q=19.0 size=   61802kB time=00:01:27.29 bitrate=5799.6kbits/s    
frame= 2186 fps= 19 q=19.0 size=   61974kB time=00:01:27.61 bitrate=5794.5kbits/s    
frame= 2196 fps= 19 q=19.0 size=   62284kB time=00:01:28.00 bitrate=5798.0kbits/s    
frame= 2207 fps= 19 q=20.0 size=   62636kB time=00:01:28.44 bitrate=5801.3kbits/s    
frame= 2223 fps= 20 q=20.0 size=   63363kB time=00:01:29.08 bitrate=5826.5kbits/s    
frame= 2236 fps= 20 q=20.0 size=   63717kB time=00:01:29.60 bitrate=5825.6kbits/s    
frame= 2246 fps= 20 q=20.0 size=   63962kB time=00:01:30.00 bitrate=5821.6kbits/s    
frame= 2255 fps= 20 q=21.0 size=   64182kB time=00:01:30.36 bitrate=5818.2kbits/s    
frame= 2264 fps= 20 q=20.0 size=   64438kB time=00:01:30.73 bitrate=5818.0kbits/s    
frame= 2275 fps= 20 q=20.0 size=   64718kB time=00:01:31.17 bitrate=5814.6kbits/s    
frame= 2287 fps= 20 q=21.0 size=   65355kB time=00:01:31.64 bitrate=5841.7kbits/s    
frame= 2297 fps= 20 q=21.0 size=   65556kB time=00:01:32.05 bitrate=5834.0kbits/s    
frame= 2306 fps= 20 q=20.0 size=   65808kB time=00:01:32.41 bitrate=5833.4kbits/s    
frame= 2317 fps= 20 q=21.0 size=   66085kB time=00:01:32.84 bitrate=5831.0kbits/s    
frame= 2332 fps= 20 q=21.0 size=   66484kB time=00:01:33.44 bitrate=5828.7kbits/s    
frame= 2345 fps= 20 q=20.0 size=   66806kB time=00:01:33.97 bitrate=5823.7kbits/s    
frame= 2356 fps= 20 q=20.0 size=   67473kB time=00:01:34.40 bitrate=5855.3kbits/s    
frame= 2364 fps= 20 q=21.0 size=   67720kB time=00:01:34.72 bitrate=5856.9kbits/s    
frame= 2374 fps= 20 q=21.0 size=   68020kB time=00:01:35.12 bitrate=5857.7kbits/s    
frame= 2383 fps= 20 q=21.0 size=   68195kB time=00:01:35.48 bitrate=5850.5kbits/s    
frame= 2395 fps= 20 q=21.0 size=   68433kB time=00:01:35.97 bitrate=5840.9kbits/s    
frame= 2410 fps= 20 q=18.0 size=   68695kB time=00:01:36.57 bitrate=5827.0kbits/s    
frame= 2422 fps= 20 q=19.0 size=   69065kB time=00:01:37.04 bitrate=5830.0kbits/s    
frame= 2434 fps= 20 q=21.0 size=   69674kB time=00:01:37.53 bitrate=5851.9kbits/s    
frame= 2440 fps= 20 q=20.0 size=   69914kB time=00:01:37.77 bitrate=5858.0kbits/s    
frame= 2445 fps= 20 q=21.0 size=   70095kB time=00:01:37.96 bitrate=5861.6kbits/s    
frame= 2455 fps= 20 q=19.0 size=   70425kB time=00:01:38.36 bitrate=5864.9kbits/s    
frame= 2467 fps= 20 q=19.0 size=   70735kB time=00:01:38.85 bitrate=5861.5kbits/s    
frame= 2480 fps= 20 q=20.0 size=   71029kB time=00:01:39.37 bitrate=5855.5kbits/s    
frame= 2492 fps= 20 q=15.0 size=   71266kB time=00:01:39.84 bitrate=5847.5kbits/s    
frame= 2505 fps= 20 q=20.0 size=   71823kB time=00:01:40.37 bitrate=5861.8kbits/s    
frame= 2518 fps= 20 q=19.0 size=   72398kB time=00:01:40.88 bitrate=5878.8kbits/s    
frame= 2538 fps= 20 q=19.0 size=   72800kB time=00:01:41.69 bitrate=5864.3kbits/s    
frame= 2550 fps= 20 q=18.0 size=   73048kB time=00:01:42.16 bitrate=5857.2kbits/s    
frame= 2565 fps= 20 q=12.0 size=   73327kB time=00:01:42.76 bitrate=5845.4kbits/s    
frame= 2584 fps= 20 q=16.0 size=   73845kB time=00:01:43.53 bitrate=5843.1kbits/s    
frame= 2588 fps= 20 q=18.0 size=   74309kB time=00:01:43.68 bitrate=5871.3kbits/s    
frame= 2600 fps= 20 q=19.0 size=   74533kB time=00:01:44.17 bitrate=5861.3kbits/s    
frame= 2614 fps= 20 q=19.0 size=   74767kB time=00:01:44.72 bitrate=5848.6kbits/s    
frame= 2629 fps= 20 q=19.0 size=   75186kB time=00:01:45.32 bitrate=5848.0kbits/s    
frame= 2645 fps= 20 q=21.0 size=   75884kB time=00:01:45.96 bitrate=5866.6kbits/s    
frame= 2659 fps= 20 q=20.0 size=   76300kB time=00:01:46.53 bitrate=5866.9kbits/s    
frame= 2668 fps= 20 q=22.0 size=   76546kB time=00:01:46.88 bitrate=5867.0kbits/s    
frame= 2679 fps= 20 q=21.0 size=   76799kB time=00:01:47.32 bitrate=5861.9kbits/s    
frame= 2686 fps= 20 q=21.0 size=   77057kB time=00:01:47.60 bitrate=5866.4kbits/s    
frame= 2700 fps= 20 q=20.0 size=   77446kB time=00:01:48.16 bitrate=5865.8kbits/s    
frame= 2710 fps= 20 q=18.0 size=   77768kB time=00:01:48.56 bitrate=5868.1kbits/s    
frame= 2727 fps= 20 q=20.0 size=   78443kB time=00:01:49.24 bitrate=5882.1kbits/s    
frame= 2741 fps= 20 q=17.0 size=   78736kB time=00:01:49.80 bitrate=5874.2kbits/s    
frame= 2755 fps= 20 q=19.0 size=   78902kB time=00:01:50.37 bitrate=5855.9kbits/s    
frame= 2762 fps= 20 q=19.0 size=   79424kB time=00:01:50.65 bitrate=5879.8kbits/s    
frame= 2773 fps= 20 q=19.0 size=   79507kB time=00:01:51.08 bitrate=5863.4kbits/s    
frame= 2787 fps= 20 q=13.0 size=   80268kB time=00:01:51.65 bitrate=5889.0kbits/s    
frame= 2811 fps= 20 q=12.0 size=   80480kB time=00:01:52.61 bitrate=5854.2kbits/s    
frame= 2826 fps= 20 q=13.0 size=   80922kB time=00:01:53.21 bitrate=5855.3kbits/s    
frame= 2845 fps= 20 q=16.0 size=   81338kB time=00:01:53.96 bitrate=5846.8kbits/s    
frame= 2857 fps= 20 q=19.0 size=   81578kB time=00:01:54.45 bitrate=5839.0kbits/s    
frame= 2869 fps= 20 q=19.0 size=   82162kB time=00:01:54.92 bitrate=5856.7kbits/s    
frame= 2878 fps= 20 q=18.0 size=   82214kB time=00:01:55.28 bitrate=5842.0kbits/s    
frame= 2885 fps= 20 q=19.0 size=   82771kB time=00:01:55.56 bitrate=5867.5kbits/s    
frame= 2895 fps= 20 q=19.0 size=   83021kB time=00:01:55.96 bitrate=5864.6kbits/s    
frame= 2910 fps= 20 q=19.0 size=   83364kB time=00:01:56.56 bitrate=5858.7kbits/s    
frame= 2918 fps= 20 q=19.0 size=   83570kB time=00:01:56.88 bitrate=5857.1kbits/s    
frame= 2925 fps= 20 q=17.0 size=   83720kB time=00:01:57.16 bitrate=5853.7kbits/s    
frame= 2932 fps= 20 q=19.0 size=   84085kB time=00:01:57.44 bitrate=5865.3kbits/s    
frame= 2941 fps= 20 q=18.0 size=   84543kB time=00:01:57.80 bitrate=5879.1kbits/s    
frame= 2951 fps= 20 q=20.0 size=   84819kB time=00:01:58.20 bitrate=5878.1kbits/s    
frame= 2960 fps= 20 q=19.0 size=   85047kB time=00:01:58.57 bitrate=5875.9kbits/s    
frame= 2972 fps= 20 q=19.0 size=   85371kB time=00:01:59.04 bitrate=5875.0kbits/s    
frame= 2986 fps= 20 q=18.0 size=   85663kB time=00:01:59.61 bitrate=5866.7kbits/s    
frame= 2999 fps= 20 q=18.0 size=   85968kB time=00:02:00.12 bitrate=5862.5kbits/s    
frame= 3014 fps= 20 q=12.0 size=   86743kB time=00:02:00.72 bitrate=5886.1kbits/s    
frame= 3031 fps= 20 q=14.0 size=   86987kB time=00:02:01.40 bitrate=5869.4kbits/s    
frame= 3041 fps= 20 q=14.0 size=   87208kB time=00:02:01.81 bitrate=5864.8kbits/s    
frame= 3054 fps= 20 q=19.0 size=   87465kB time=00:02:02.32 bitrate=5857.4kbits/s    
frame= 3059 fps= 20 q=21.0 size=   87892kB time=00:02:02.53 bitrate=5875.8kbits/s    
frame= 3069 fps= 20 q=19.0 size=   88061kB time=00:02:02.92 bitrate=5868.7kbits/s    
frame= 3081 fps= 20 q=20.0 size=   88682kB time=00:02:03.41 bitrate=5886.6kbits/s    
frame= 3093 fps= 20 q=16.0 size=   88969kB time=00:02:03.88 bitrate=5883.3kbits/s    
frame= 3101 fps= 20 q=14.0 size=   89226kB time=00:02:04.20 bitrate=5885.0kbits/s    
frame= 3109 fps= 20 q=13.0 size=   89450kB time=00:02:04.52 bitrate=5884.6kbits/s    
frame= 3125 fps= 20 q=10.0 size=   89760kB time=00:02:05.16 bitrate=5874.8kbits/s    
frame= 3144 fps= 20 q=11.0 size=   90162kB time=00:02:05.93 bitrate=5865.2kbits/s    
frame= 3165 fps= 20 q=11.0 size=   90789kB time=00:02:06.76 bitrate=5867.2kbits/s    
frame= 3183 fps= 20 q=9.0 size=   91225kB time=00:02:07.48 bitrate=5861.9kbits/s    
frame= 3194 fps= 20 q=15.0 size=   91472kB time=00:02:07.93 bitrate=5857.1kbits/s    
frame= 3204 fps= 20 q=16.0 size=   91911kB time=00:02:08.32 bitrate=5867.7kbits/s    
frame= 3215 fps= 20 q=16.0 size=   92132kB time=00:02:08.76 bitrate=5861.2kbits/s    
frame= 3226 fps= 20 q=19.0 size=   92595kB time=00:02:09.21 bitrate=5870.3kbits/s    
frame= 3235 fps= 20 q=20.0 size=   92829kB time=00:02:09.57 bitrate=5868.7kbits/s    
frame= 3245 fps= 20 q=20.0 size=   93059kB time=00:02:09.96 bitrate=5865.8kbits/s    
frame= 3255 fps= 20 q=19.0 size=   93296kB time=00:02:10.36 bitrate=5862.5kbits/s    
frame= 3262 fps= 20 q=23.0 size=   93733kB time=00:02:10.64 bitrate=5877.4kbits/s    
frame= 3272 fps= 20 q=22.0 size=   94046kB time=00:02:11.05 bitrate=5878.8kbits/s    
frame= 3281 fps= 20 q=22.0 size=   94371kB time=00:02:11.41 bitrate=5882.9kbits/s    
frame= 3291 fps= 20 q=21.0 size=   94862kB time=00:02:11.81 bitrate=5895.3kbits/s    
frame= 3302 fps= 20 q=20.0 size=   95347kB time=00:02:12.24 bitrate=5906.3kbits/s    
frame= 3311 fps= 20 q=19.0 size=   95479kB time=00:02:12.60 bitrate=5898.3kbits/s    
frame= 3323 fps= 20 q=19.0 size=   95672kB time=00:02:13.09 bitrate=5888.5kbits/s    
frame= 3333 fps= 20 q=20.0 size=   95831kB time=00:02:13.48 bitrate=5881.3kbits/s    
frame= 3345 fps= 20 q=19.0 size=   96109kB time=00:02:13.97 bitrate=5876.7kbits/s    
frame= 3355 fps= 20 q=19.0 size=   96355kB time=00:02:14.37 bitrate=5874.0kbits/s    
frame= 3370 fps= 20 q=20.0 size=   96855kB time=00:02:14.97 bitrate=5878.4kbits/s    
frame= 3378 fps= 20 q=21.0 size=   97354kB time=00:02:15.29 bitrate=5894.7kbits/s    
frame= 3391 fps= 20 q=22.0 size=   97738kB time=00:02:15.80 bitrate=5895.6kbits/s    
frame= 3400 fps= 20 q=22.0 size=   97980kB time=00:02:16.17 bitrate=5894.4kbits/s    
frame= 3408 fps= 20 q=22.0 size=   98249kB time=00:02:16.49 bitrate=5896.8kbits/s    
frame= 3416 fps= 20 q=22.0 size=   98467kB time=00:02:16.81 bitrate=5896.0kbits/s    
frame= 3426 fps= 20 q=22.0 size=   98760kB time=00:02:17.21 bitrate=5896.1kbits/s    
frame= 3441 fps= 20 q=23.0 size=   99397kB time=00:02:17.81 bitrate=5908.4kbits/s    
frame= 3453 fps= 20 q=22.0 size=   99727kB time=00:02:18.28 bitrate=5907.9kbits/s    
frame= 3466 fps= 20 q=21.0 size=  100082kB time=00:02:18.81 bitrate=5906.2kbits/s    
frame= 3476 fps= 20 q=21.0 size=  100375kB time=00:02:19.20 bitrate=5907.1kbits/s    
frame= 3482 fps= 20 q=21.0 size=  100723kB time=00:02:19.45 bitrate=5916.7kbits/s    
frame= 3496 fps= 20 q=21.0 size=  100927kB time=00:02:20.01 bitrate=5905.2kbits/s    
frame= 3509 fps= 20 q=18.0 size=  101122kB time=00:02:20.52 bitrate=5895.1kbits/s    
frame= 3517 fps= 20 q=21.0 size=  101361kB time=00:02:20.84 bitrate=5895.6kbits/s    
frame= 3526 fps= 20 q=22.0 size=  101767kB time=00:02:21.20 bitrate=5904.0kbits/s    
frame= 3536 fps= 20 q=21.0 size=  102140kB time=00:02:21.61 bitrate=5908.7kbits/s    
frame= 3546 fps= 20 q=22.0 size=  102527kB time=00:02:22.01 bitrate=5914.1kbits/s    
frame= 3554 fps= 20 q=22.0 size=  102807kB time=00:02:22.33 bitrate=5917.0kbits/s    
frame= 3564 fps= 20 q=22.0 size=  103141kB time=00:02:22.72 bitrate=5920.2kbits/s    
frame= 3571 fps= 20 q=22.0 size=  103459kB time=00:02:23.01 bitrate=5926.0kbits/s    
frame= 3589 fps= 20 q=17.0 size=  103893kB time=00:02:23.72 bitrate=5921.8kbits/s    
frame= 3599 fps= 20 q=12.0 size=  104267kB time=00:02:24.12 bitrate=5926.4kbits/s    
frame= 3618 fps= 20 q=13.0 size=  104582kB time=00:02:24.89 bitrate=5912.7kbits/s    
frame= 3638 fps= 20 q=15.0 size=  104869kB time=00:02:25.68 bitrate=5896.8kbits/s    
frame= 3656 fps= 20 q=15.0 size=  105294kB time=00:02:26.41 bitrate=5891.4kbits/s    
frame= 3664 fps= 20 q=19.0 size=  105467kB time=00:02:26.73 bitrate=5888.3kbits/s    
frame= 3670 fps= 20 q=22.0 size=  105787kB time=00:02:26.96 bitrate=5896.7kbits/s    
frame= 3677 fps= 20 q=22.0 size=  106131kB time=00:02:27.24 bitrate=5904.7kbits/s    
frame= 3687 fps= 20 q=23.0 size=  106555kB time=00:02:27.64 bitrate=5912.0kbits/s    
frame= 3698 fps= 20 q=23.0 size=  106867kB time=00:02:28.09 bitrate=5911.4kbits/s    
frame= 3708 fps= 20 q=23.0 size=  107080kB time=00:02:28.48 bitrate=5907.8kbits/s    
frame= 3717 fps= 20 q=23.0 size=  107243kB time=00:02:28.84 bitrate=5902.4kbits/s    
frame= 3726 fps= 20 q=22.0 size=  107578kB time=00:02:29.20 bitrate=5906.5kbits/s    
frame= 3733 fps= 20 q=22.0 size=  107672kB time=00:02:29.48 bitrate=5900.7kbits/s    
frame= 3740 fps= 20 q=22.0 size=  107839kB time=00:02:29.76 bitrate=5898.9kbits/s    
frame= 3749 fps= 20 q=21.0 size=  108131kB time=00:02:30.12 bitrate=5900.6kbits/s    
frame= 3754 fps= 20 q=22.0 size=  108377kB time=00:02:30.33 bitrate=5905.6kbits/s    
frame= 3761 fps= 20 q=22.0 size=  108730kB time=00:02:30.61 bitrate=5913.9kbits/s    
frame= 3769 fps= 20 q=21.0 size=  109057kB time=00:02:30.93 bitrate=5919.1kbits/s    
frame= 3777 fps= 20 q=19.0 size=  109313kB time=00:02:31.25 bitrate=5920.5kbits/s    
frame= 3783 fps= 20 q=20.0 size=  109526kB time=00:02:31.48 bitrate=5922.8kbits/s    
frame= 3791 fps= 20 q=19.0 size=  109627kB time=00:02:31.80 bitrate=5915.8kbits/s    
frame= 3808 fps= 20 q=17.0 size=  110086kB time=00:02:32.49 bitrate=5914.0kbits/s    
frame= 3821 fps= 20 q=17.0 size=  110315kB time=00:02:33.00 bitrate=5906.4kbits/s    
frame= 3830 fps= 20 q=18.0 size=  110671kB time=00:02:33.36 bitrate=5911.5kbits/s    
frame= 3845 fps= 20 q=14.0 size=  110959kB time=00:02:33.96 bitrate=5903.9kbits/s    
frame= 3854 fps= 20 q=19.0 size=  111255kB time=00:02:34.32 bitrate=5905.7kbits/s    
frame= 3864 fps= 20 q=19.0 size=  111488kB time=00:02:34.73 bitrate=5902.6kbits/s    
frame= 3872 fps= 20 q=20.0 size=  111952kB time=00:02:35.05 bitrate=5914.9kbits/s    
frame= 3886 fps= 20 q=18.0 size=  112209kB time=00:02:35.60 bitrate=5907.4kbits/s    
frame= 3898 fps= 20 q=18.0 size=  112796kB time=00:02:36.09 bitrate=5919.6kbits/s    
frame= 3914 fps= 20 q=18.0 size=  113157kB time=00:02:36.73 bitrate=5914.3kbits/s    
frame= 3928 fps= 20 q=18.0 size=  113456kB time=00:02:37.29 bitrate=5909.0kbits/s    
frame= 3936 fps= 20 q=18.0 size=  113624kB time=00:02:37.61 bitrate=5905.7kbits/s    
frame= 3951 fps= 20 q=15.0 size=  114271kB time=00:02:38.20 bitrate=5916.9kbits/s    
frame= 3962 fps= 20 q=14.0 size=  114405kB time=00:02:38.65 bitrate=5907.2kbits/s    
frame= 3970 fps= 20 q=13.0 size=  114831kB time=00:02:38.97 bitrate=5917.2kbits/s    
frame= 3977 fps= 20 q=14.0 size=  114926kB time=00:02:39.25 bitrate=5911.8kbits/s    
frame= 3985 fps= 20 q=14.0 size=  115070kB time=00:02:39.57 bitrate=5907.3kbits/s    
frame= 3996 fps= 20 q=12.0 size=  115312kB time=00:02:40.00 bitrate=5904.0kbits/s    
frame= 4006 fps= 20 q=17.0 size=  115627kB time=00:02:40.40 bitrate=5905.2kbits/s    
frame= 4016 fps= 20 q=19.0 size=  116181kB time=00:02:40.81 bitrate=5918.5kbits/s    
frame= 4026 fps= 20 q=20.0 size=  116521kB time=00:02:41.21 bitrate=5920.9kbits/s    
frame= 4037 fps= 20 q=20.0 size=  116842kB time=00:02:41.64 bitrate=5921.5kbits/s    
frame= 4045 fps= 20 q=19.0 size=  117161kB time=00:02:41.96 bitrate=5925.9kbits/s    
frame= 4063 fps= 20 q=19.0 size=  117329kB time=00:02:42.68 bitrate=5908.0kbits/s    
frame= 4072 fps= 20 q=20.0 size=  117532kB time=00:02:43.05 bitrate=5905.1kbits/s    
frame= 4080 fps= 20 q=22.0 size=  117799kB time=00:02:43.37 bitrate=5906.8kbits/s    
frame= 4089 fps= 20 q=22.0 size=  118272kB time=00:02:43.73 bitrate=5917.4kbits/s    
frame= 4097 fps= 20 q=23.0 size=  118544kB time=00:02:44.05 bitrate=5919.5kbits/s    
frame= 4106 fps= 20 q=24.0 size=  118834kB time=00:02:44.41 bitrate=5920.9kbits/s    
frame= 4118 fps= 20 q=24.0 size=  119140kB time=00:02:44.88 bitrate=5919.2kbits/s    
frame= 4128 fps= 20 q=25.0 size=  119432kB time=00:02:45.29 bitrate=5919.2kbits/s    
frame= 4139 fps= 20 q=25.0 size=  119760kB time=00:02:45.73 bitrate=5919.4kbits/s    
frame= 4146 fps= 20 q=26.0 size=  119951kB time=00:02:46.01 bitrate=5918.9kbits/s    
frame= 4157 fps= 20 q=25.0 size=  120335kB time=00:02:46.44 bitrate=5922.7kbits/s    
frame= 4165 fps= 20 q=24.0 size=  120545kB time=00:02:46.76 bitrate=5921.6kbits/s    
frame= 4173 fps= 20 q=24.0 size=  120828kB time=00:02:47.08 bitrate=5924.2kbits/s    
frame= 4181 fps= 20 q=23.0 size=  121202kB time=00:02:47.40 bitrate=5931.1kbits/s    
frame= 4189 fps= 20 q=23.0 size=  121556kB time=00:02:47.72 bitrate=5937.1kbits/s    
frame= 4198 fps= 20 q=23.0 size=  121929kB time=00:02:48.08 bitrate=5942.5kbits/s    
frame= 4209 fps= 20 q=21.0 size=  122184kB time=00:02:48.53 bitrate=5939.1kbits/s    
frame= 4218 fps= 20 q=21.0 size=  122373kB time=00:02:48.89 bitrate=5935.5kbits/s    
frame= 4230 fps= 20 q=19.0 size=  122808kB time=00:02:49.36 bitrate=5940.1kbits/s    
frame= 4246 fps= 20 q=18.0 size=  123030kB time=00:02:50.00 bitrate=5928.4kbits/s    
frame= 4262 fps= 20 q=20.0 size=  123410kB time=00:02:50.64 bitrate=5924.4kbits/s    
frame= 4271 fps= 20 q=-1.0 Lsize=  125201kB time=00:02:50.85 bitrate=6002.9kbits/s    
video:117068kB audio:8008kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.100356%
[libx264 @ 0x21f3000] frame I:60    Avg QP: 8.90  size:312893
[libx264 @ 0x21f3000] frame P:1530  Avg QP:12.30  size: 48684
[libx264 @ 0x21f3000] frame B:2681  Avg QP:16.63  size:  9928
[libx264 @ 0x21f3000] consecutive B-frames: 14.6%  3.4%  5.3% 76.7%
[libx264 @ 0x21f3000] mb I  I16..4: 16.9% 57.5% 25.6%
[libx264 @ 0x21f3000] mb P  I16..4:  2.5% 10.2%  2.1%  P16..4: 19.6% 11.1%  6.4%  0.0%  0.0%    skip:48.2%
[libx264 @ 0x21f3000] mb B  I16..4:  0.2%  0.9%  0.2%  B16..8: 20.1%  4.6%  1.1%  direct: 2.7%  skip:70.2%  L0:43.5% L1:49.3% BI: 7.3%
[libx264 @ 0x21f3000] 8x8 transform intra:67.0% inter:62.6%
[libx264 @ 0x21f3000] coded y,uvDC,uvAC intra: 70.9% 81.4% 63.1% inter: 9.5% 13.6% 3.0%
[libx264 @ 0x21f3000] i16 v,h,dc,p: 27% 34%  6% 34%
[libx264 @ 0x21f3000] i8 v,h,dc,ddl,ddr,vr,hd,vl,hu: 28% 21% 11%  5%  6%  8%  7%  8%  7%
[libx264 @ 0x21f3000] i4 v,h,dc,ddl,ddr,vr,hd,vl,hu: 33% 22%  9%  4%  8%  7%  6%  6%  4%
[libx264 @ 0x21f3000] i8c dc,h,v,p: 43% 25% 21% 12%
[libx264 @ 0x21f3000] Weighted P-Frames: Y:0.0% UV:0.0%
[libx264 @ 0x21f3000] ref P L0: 78.4%  8.0% 11.1%  2.5%
[libx264 @ 0x21f3000] ref B L0: 94.1%  5.1%  0.7%
[libx264 @ 0x21f3000] ref B L1: 97.0%  3.0%
[libx264 @ 0x21f3000] kb/s:5613.51