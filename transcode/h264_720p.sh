#!/bin/bash
# https://google.github.io/shaka-packager/html/tutorials/encoding.html
# Transcode h264_720p

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
       -vf "scale=-2:720" \
       -c:v libx264 -profile:v main -level:v 4.0 \
       -x264opts scenecut=0:open_gop=0:min-keyint=72:keyint=72 \
       -minrate 3000k -maxrate 3000k -bufsize 3000k -b:v 3000k \
       -y ${FILENAME}.t/h264_main_720p_3000.mp4
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
[libx264 @ 0x19b2900] using SAR=1/1
[libx264 @ 0x19b2900] using cpu capabilities: MMX2 SSE2Fast SSSE3 SSE4.2 AVX AVX2 FMA3 LZCNT BMI2
[libx264 @ 0x19b2900] profile Main, level 4.0
[libx264 @ 0x19b2900] 264 - core 142 r2495 6a301b6 - H.264/MPEG-4 AVC codec - Copyleft 2003-2014 - http://www.videolan.org/x264.html - options: cabac=1 ref=3 deblock=1:0:0 analyse=0x1:0x111 me=hex subme=7 psy=1 psy_rd=1.00:0.00 mixed_ref=1 me_range=16 chroma_me=1 trellis=1 8x8dct=0 cqm=0 deadzone=21,11 fast_pskip=1 chroma_qp_offset=-2 threads=3 lookahead_threads=1 sliced_threads=0 nr=0 decimate=1 interlaced=0 bluray_compat=0 constrained_intra=0 bframes=3 b_pyramid=2 b_adapt=1 b_bias=0 direct=1 weightb=1 open_gop=0 weightp=2 keyint=72 keyint_min=37 scenecut=0 intra_refresh=0 rc_lookahead=40 rc=cbr mbtree=1 bitrate=3000 ratetol=1.0 qcomp=0.60 qpmin=0 qpmax=69 qpstep=4 vbv_maxrate=3000 vbv_bufsize=3000 nal_hrd=none filler=0 ip_ratio=1.40 aq=1:1.00
[mp4 @ 0x1a03f20] Codec for stream 1 does not use global headers but container format requires global headers
Output #0, mp4, to 'big_buck_bunny_720p_30mb.mp4.t/h264_main_720p_3000.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    encoder         : Lavf56.40.101
    Stream #0:0(und): Video: h264 (libx264) ([33][0][0][0] / 0x0021), yuv420p, 1280x720 [SAR 1:1 DAR 16:9], q=-1--1, 3000 kb/s, 25 fps, 12800 tbn, 25 tbc (default)
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
frame=   46 fps=0.0 q=0.0 size=       0kB time=00:00:01.92 bitrate=   0.2kbits/s    
frame=   57 fps= 42 q=29.0 size=     152kB time=00:00:02.36 bitrate= 524.5kbits/s    
frame=   65 fps= 34 q=26.0 size=     242kB time=00:00:02.68 bitrate= 736.7kbits/s    
frame=   73 fps= 30 q=25.0 size=     344kB time=00:00:03.00 bitrate= 935.8kbits/s    
frame=   81 fps= 27 q=25.0 size=     475kB time=00:00:03.32 bitrate=1168.3kbits/s    
frame=   89 fps= 25 q=26.0 size=     587kB time=00:00:03.64 bitrate=1319.3kbits/s    
frame=   99 fps= 24 q=26.0 size=     770kB time=00:00:04.05 bitrate=1556.7kbits/s    
frame=  108 fps= 23 q=25.0 size=     884kB time=00:00:04.41 bitrate=1640.4kbits/s    
frame=  115 fps= 20 q=25.0 size=     994kB time=00:00:04.69 bitrate=1734.5kbits/s    
frame=  120 fps= 19 q=25.0 size=    1204kB time=00:00:04.88 bitrate=2018.9kbits/s    
frame=  129 fps= 19 q=20.0 size=    1342kB time=00:00:05.24 bitrate=2094.5kbits/s    
frame=  139 fps= 19 q=21.0 size=    1466kB time=00:00:05.65 bitrate=2124.8kbits/s    
frame=  147 fps= 19 q=20.0 size=    1536kB time=00:00:05.97 bitrate=2107.0kbits/s    
frame=  158 fps= 19 q=19.0 size=    1682kB time=00:00:06.40 bitrate=2152.8kbits/s    
frame=  165 fps= 19 q=19.0 size=    1797kB time=00:00:06.69 bitrate=2197.2kbits/s    
frame=  170 fps= 18 q=20.0 size=    1855kB time=00:00:06.89 bitrate=2205.3kbits/s    
frame=  178 fps= 18 q=19.0 size=    1935kB time=00:00:07.21 bitrate=2197.8kbits/s    
frame=  182 fps= 17 q=21.0 size=    1995kB time=00:00:07.36 bitrate=2220.5kbits/s    
frame=  186 fps= 17 q=20.0 size=    2058kB time=00:00:07.53 bitrate=2239.2kbits/s    
frame=  190 fps= 16 q=20.0 size=    2112kB time=00:00:07.68 bitrate=2253.1kbits/s    
frame=  193 fps= 16 q=21.0 size=    2398kB time=00:00:07.80 bitrate=2516.2kbits/s    
frame=  201 fps= 16 q=19.0 size=    2456kB time=00:00:08.12 bitrate=2475.5kbits/s    
frame=  208 fps= 16 q=20.0 size=    2515kB time=00:00:08.40 bitrate=2451.1kbits/s    
frame=  217 fps= 16 q=21.0 size=    2632kB time=00:00:08.76 bitrate=2458.7kbits/s    
frame=  225 fps= 16 q=21.0 size=    2748kB time=00:00:09.08 bitrate=2476.9kbits/s    
frame=  231 fps= 16 q=21.0 size=    2856kB time=00:00:09.32 bitrate=2509.4kbits/s    
frame=  240 fps= 15 q=19.0 size=    3014kB time=00:00:09.68 bitrate=2549.1kbits/s    
frame=  247 fps= 15 q=16.0 size=    3167kB time=00:00:09.96 bitrate=2603.9kbits/s    
frame=  254 fps= 15 q=16.0 size=    3305kB time=00:00:10.24 bitrate=2644.0kbits/s    
frame=  264 fps= 15 q=16.0 size=    3522kB time=00:00:10.64 bitrate=2710.3kbits/s    
frame=  277 fps= 16 q=7.0 size=    3581kB time=00:00:11.17 bitrate=2624.0kbits/s    
frame=  296 fps= 16 q=9.0 size=    3753kB time=00:00:11.92 bitrate=2578.2kbits/s    
frame=  313 fps= 17 q=11.0 size=    3988kB time=00:00:12.60 bitrate=2591.5kbits/s    
frame=  327 fps= 17 q=7.0 size=    4221kB time=00:00:13.16 bitrate=2626.7kbits/s    
frame=  339 fps= 17 q=12.0 size=    4556kB time=00:00:13.65 bitrate=2733.9kbits/s    
frame=  355 fps= 18 q=8.0 size=    4679kB time=00:00:14.29 bitrate=2681.6kbits/s    
frame=  370 fps= 18 q=15.0 size=    4842kB time=00:00:14.89 bitrate=2664.1kbits/s    
frame=  379 fps= 18 q=15.0 size=    5063kB time=00:00:15.25 bitrate=2719.0kbits/s    
frame=  391 fps= 18 q=16.0 size=    5232kB time=00:00:15.72 bitrate=2726.1kbits/s    
frame=  400 fps= 18 q=15.0 size=    5360kB time=00:00:16.08 bitrate=2729.5kbits/s    
frame=  411 fps= 18 q=16.0 size=    5681kB time=00:00:16.53 bitrate=2815.1kbits/s    
frame=  424 fps= 18 q=15.0 size=    5803kB time=00:00:17.04 bitrate=2788.9kbits/s    
frame=  434 fps= 18 q=16.0 size=    5970kB time=00:00:17.45 bitrate=2802.5kbits/s    
frame=  445 fps= 18 q=18.0 size=    6120kB time=00:00:17.89 bitrate=2801.2kbits/s    
frame=  458 fps= 18 q=17.0 size=    6369kB time=00:00:18.41 bitrate=2833.8kbits/s    
frame=  470 fps= 18 q=18.0 size=    6473kB time=00:00:18.88 bitrate=2808.7kbits/s    
frame=  479 fps= 18 q=19.0 size=    6587kB time=00:00:19.24 bitrate=2804.3kbits/s    
frame=  489 fps= 18 q=18.0 size=    6932kB time=00:00:19.64 bitrate=2890.4kbits/s    
frame=  496 fps= 18 q=19.0 size=    7041kB time=00:00:19.92 bitrate=2894.6kbits/s    
frame=  501 fps= 18 q=19.0 size=    7093kB time=00:00:20.13 bitrate=2885.5kbits/s    
frame=  506 fps= 18 q=19.0 size=    7163kB time=00:00:20.33 bitrate=2886.1kbits/s    
frame=  511 fps= 18 q=19.0 size=    7233kB time=00:00:20.52 bitrate=2887.1kbits/s    
frame=  518 fps= 18 q=19.0 size=    7363kB time=00:00:20.80 bitrate=2899.7kbits/s    
frame=  525 fps= 18 q=20.0 size=    7479kB time=00:00:21.09 bitrate=2903.9kbits/s    
frame=  533 fps= 17 q=20.0 size=    7610kB time=00:00:21.41 bitrate=2910.6kbits/s    
frame=  539 fps= 17 q=20.0 size=    7722kB time=00:00:21.65 bitrate=2921.3kbits/s    
frame=  547 fps= 17 q=20.0 size=    7854kB time=00:00:21.97 bitrate=2928.2kbits/s    
frame=  557 fps= 17 q=21.0 size=    8061kB time=00:00:22.37 bitrate=2950.9kbits/s    
frame=  564 fps= 17 q=19.0 size=    8168kB time=00:00:22.65 bitrate=2953.6kbits/s    
frame=  570 fps= 17 q=19.0 size=    8253kB time=00:00:22.89 bitrate=2953.6kbits/s    
frame=  574 fps= 17 q=19.0 size=    8317kB time=00:00:23.04 bitrate=2957.3kbits/s    
frame=  581 fps= 17 q=20.0 size=    8466kB time=00:00:23.33 bitrate=2971.7kbits/s    
frame=  588 fps= 17 q=19.0 size=    8606kB time=00:00:23.61 bitrate=2985.4kbits/s    
frame=  592 fps= 17 q=20.0 size=    8764kB time=00:00:23.76 bitrate=3020.9kbits/s    
frame=  608 fps= 17 q=18.0 size=    8839kB time=00:00:24.40 bitrate=2966.9kbits/s    
frame=  621 fps= 17 q=15.0 size=    8916kB time=00:00:24.93 bitrate=2928.9kbits/s    
frame=  638 fps= 17 q=12.0 size=    9395kB time=00:00:25.60 bitrate=3006.5kbits/s    
frame=  651 fps= 17 q=15.0 size=    9509kB time=00:00:26.13 bitrate=2980.9kbits/s    
frame=  661 fps= 17 q=13.0 size=    9606kB time=00:00:26.53 bitrate=2965.1kbits/s    
frame=  669 fps= 17 q=12.0 size=    9710kB time=00:00:26.85 bitrate=2961.7kbits/s    
frame=  676 fps= 17 q=14.0 size=    9814kB time=00:00:27.13 bitrate=2962.7kbits/s    
frame=  685 fps= 17 q=7.0 size=    9917kB time=00:00:27.49 bitrate=2954.4kbits/s    
frame=  692 fps= 17 q=24.0 size=   10018kB time=00:00:27.77 bitrate=2954.6kbits/s    
frame=  699 fps= 17 q=19.0 size=   10205kB time=00:00:28.05 bitrate=2979.9kbits/s    
frame=  705 fps= 17 q=18.0 size=   10291kB time=00:00:28.28 bitrate=2980.1kbits/s    
frame=  710 fps= 17 q=19.0 size=   10328kB time=00:00:28.48 bitrate=2970.9kbits/s    
frame=  717 fps= 17 q=21.0 size=   10440kB time=00:00:28.77 bitrate=2971.8kbits/s    
frame=  723 fps= 17 q=22.0 size=   10551kB time=00:00:29.01 bitrate=2979.1kbits/s    
frame=  731 fps= 17 q=24.0 size=   10681kB time=00:00:29.33 bitrate=2982.9kbits/s    
frame=  735 fps= 17 q=24.0 size=   10739kB time=00:00:29.48 bitrate=2983.9kbits/s    
frame=  744 fps= 17 q=23.0 size=   10947kB time=00:00:29.84 bitrate=3004.8kbits/s    
frame=  751 fps= 16 q=26.0 size=   11047kB time=00:00:30.12 bitrate=3004.2kbits/s    
frame=  758 fps= 16 q=27.0 size=   11148kB time=00:00:30.40 bitrate=3004.0kbits/s    
frame=  763 fps= 16 q=27.0 size=   11231kB time=00:00:30.61 bitrate=3005.5kbits/s    
frame=  771 fps= 16 q=27.0 size=   11453kB time=00:00:30.93 bitrate=3033.0kbits/s    
frame=  777 fps= 16 q=28.0 size=   11554kB time=00:00:31.16 bitrate=3036.7kbits/s    
frame=  784 fps= 16 q=28.0 size=   11653kB time=00:00:31.44 bitrate=3035.9kbits/s    
frame=  791 fps= 16 q=27.0 size=   11781kB time=00:00:31.72 bitrate=3042.4kbits/s    
frame=  796 fps= 16 q=28.0 size=   11870kB time=00:00:31.93 bitrate=3044.8kbits/s    
frame=  799 fps= 16 q=28.0 size=   11926kB time=00:00:32.04 bitrate=3049.0kbits/s    
frame=  806 fps= 16 q=29.0 size=   12020kB time=00:00:32.32 bitrate=3046.7kbits/s    
frame=  814 fps= 16 q=28.0 size=   12151kB time=00:00:32.64 bitrate=3049.8kbits/s    
frame=  820 fps= 16 q=27.0 size=   12225kB time=00:00:32.89 bitrate=3044.3kbits/s    
frame=  825 fps= 16 q=26.0 size=   12314kB time=00:00:33.08 bitrate=3048.7kbits/s    
frame=  832 fps= 16 q=25.0 size=   12440kB time=00:00:33.36 bitrate=3054.3kbits/s    
frame=  838 fps= 16 q=23.0 size=   12545kB time=00:00:33.60 bitrate=3058.7kbits/s    
frame=  845 fps= 16 q=24.0 size=   12746kB time=00:00:33.89 bitrate=3080.2kbits/s    
frame=  851 fps= 16 q=24.0 size=   12842kB time=00:00:34.13 bitrate=3082.1kbits/s    
frame=  859 fps= 16 q=25.0 size=   12952kB time=00:00:34.45 bitrate=3079.6kbits/s    
frame=  863 fps= 16 q=25.0 size=   12993kB time=00:00:34.60 bitrate=3075.9kbits/s    
frame=  868 fps= 15 q=22.0 size=   13037kB time=00:00:34.81 bitrate=3067.4kbits/s    
frame=  874 fps= 15 q=22.0 size=   13114kB time=00:00:35.05 bitrate=3065.1kbits/s    
frame=  881 fps= 15 q=22.0 size=   13193kB time=00:00:35.32 bitrate=3059.3kbits/s    
frame=  889 fps= 15 q=24.0 size=   13324kB time=00:00:35.64 bitrate=3061.8kbits/s    
frame=  899 fps= 15 q=21.0 size=   13428kB time=00:00:36.05 bitrate=3051.1kbits/s    
frame=  907 fps= 15 q=20.0 size=   13512kB time=00:00:36.37 bitrate=3043.2kbits/s    
frame=  914 fps= 15 q=20.0 size=   13743kB time=00:00:36.65 bitrate=3071.7kbits/s    
frame=  921 fps= 15 q=20.0 size=   13873kB time=00:00:36.92 bitrate=3077.5kbits/s    
frame=  929 fps= 15 q=20.0 size=   14014kB time=00:00:37.24 bitrate=3082.1kbits/s    
frame=  933 fps= 15 q=19.0 size=   14084kB time=00:00:37.41 bitrate=3083.3kbits/s    
frame=  939 fps= 15 q=14.0 size=   14175kB time=00:00:37.65 bitrate=3083.9kbits/s    
frame=  949 fps= 15 q=14.0 size=   14314kB time=00:00:38.05 bitrate=3081.0kbits/s    
frame=  960 fps= 15 q=13.0 size=   14484kB time=00:00:38.48 bitrate=3083.2kbits/s    
frame=  972 fps= 15 q=11.0 size=   14584kB time=00:00:38.97 bitrate=3065.4kbits/s    
frame=  987 fps= 15 q=15.0 size=   14931kB time=00:00:39.57 bitrate=3090.9kbits/s    
frame= 1003 fps= 16 q=13.0 size=   15080kB time=00:00:40.21 bitrate=3072.0kbits/s    
frame= 1018 fps= 16 q=13.0 size=   15228kB time=00:00:40.81 bitrate=3056.8kbits/s    
frame= 1029 fps= 16 q=13.0 size=   15418kB time=00:00:41.25 bitrate=3061.3kbits/s    
frame= 1043 fps= 16 q=11.0 size=   15587kB time=00:00:41.81 bitrate=3053.8kbits/s    
frame= 1056 fps= 16 q=12.0 size=   16073kB time=00:00:42.32 bitrate=3110.9kbits/s    
frame= 1065 fps= 16 q=13.0 size=   16126kB time=00:00:42.68 bitrate=3094.6kbits/s    
frame= 1074 fps= 16 q=12.0 size=   16169kB time=00:00:43.05 bitrate=3076.8kbits/s    
frame= 1088 fps= 16 q=9.0 size=   16367kB time=00:00:43.60 bitrate=3074.8kbits/s    
frame= 1099 fps= 16 q=20.0 size=   16552kB time=00:00:44.05 bitrate=3077.9kbits/s    
frame= 1115 fps= 16 q=17.0 size=   16717kB time=00:00:44.69 bitrate=3064.1kbits/s    
frame= 1128 fps= 16 q=19.0 size=   17117kB time=00:00:45.20 bitrate=3101.9kbits/s    
frame= 1141 fps= 16 q=12.0 size=   17377kB time=00:00:45.73 bitrate=3112.3kbits/s    
frame= 1157 fps= 16 q=9.0 size=   17556kB time=00:00:46.37 bitrate=3101.0kbits/s    
frame= 1176 fps= 16 q=11.0 size=   17713kB time=00:00:47.12 bitrate=3079.1kbits/s    
frame= 1193 fps= 17 q=10.0 size=   17910kB time=00:00:47.80 bitrate=3068.8kbits/s    
frame= 1210 fps= 17 q=10.0 size=   18243kB time=00:00:48.49 bitrate=3082.0kbits/s    
frame= 1217 fps= 17 q=11.0 size=   18317kB time=00:00:48.76 bitrate=3076.9kbits/s    
frame= 1227 fps= 17 q=13.0 size=   18423kB time=00:00:49.17 bitrate=3069.1kbits/s    
frame= 1241 fps= 17 q=12.0 size=   18595kB time=00:00:49.72 bitrate=3063.3kbits/s    
frame= 1254 fps= 17 q=13.0 size=   18828kB time=00:00:50.24 bitrate=3070.1kbits/s    
frame= 1269 fps= 17 q=14.0 size=   19070kB time=00:00:50.85 bitrate=3071.7kbits/s    
frame= 1283 fps= 17 q=11.0 size=   19520kB time=00:00:51.41 bitrate=3110.3kbits/s    
frame= 1296 fps= 17 q=10.0 size=   19711kB time=00:00:51.92 bitrate=3109.7kbits/s    
frame= 1312 fps= 17 q=9.0 size=   19865kB time=00:00:52.56 bitrate=3095.9kbits/s    
frame= 1329 fps= 17 q=0.0 size=   20004kB time=00:00:53.24 bitrate=3077.5kbits/s    
frame= 1344 fps= 17 q=16.0 size=   20280kB time=00:00:53.84 bitrate=3085.4kbits/s    
frame= 1353 fps= 17 q=20.0 size=   20540kB time=00:00:54.20 bitrate=3104.0kbits/s    
frame= 1359 fps= 17 q=18.0 size=   20590kB time=00:00:54.44 bitrate=3098.1kbits/s    
frame= 1372 fps= 17 q=17.0 size=   20708kB time=00:00:54.97 bitrate=3085.7kbits/s    
frame= 1387 fps= 17 q=19.0 size=   20889kB time=00:00:55.57 bitrate=3079.2kbits/s    
frame= 1396 fps= 17 q=18.0 size=   20986kB time=00:00:55.93 bitrate=3073.5kbits/s    
frame= 1400 fps= 17 q=18.0 size=   21126kB time=00:00:56.08 bitrate=3085.7kbits/s    
frame= 1408 fps= 17 q=19.0 size=   21391kB time=00:00:56.40 bitrate=3106.7kbits/s    
frame= 1421 fps= 17 q=24.0 size=   21697kB time=00:00:56.93 bitrate=3121.7kbits/s    
frame= 1430 fps= 17 q=20.0 size=   21758kB time=00:00:57.28 bitrate=3111.7kbits/s    
frame= 1441 fps= 17 q=20.0 size=   21846kB time=00:00:57.72 bitrate=3100.1kbits/s    
frame= 1453 fps= 17 q=18.0 size=   21960kB time=00:00:58.21 bitrate=3090.0kbits/s    
frame= 1464 fps= 17 q=15.0 size=   22080kB time=00:00:58.64 bitrate=3084.3kbits/s    
frame= 1474 fps= 17 q=15.0 size=   22233kB time=00:00:59.05 bitrate=3084.4kbits/s    
frame= 1485 fps= 17 q=15.0 size=   22395kB time=00:00:59.49 bitrate=3083.5kbits/s    
frame= 1498 fps= 17 q=16.0 size=   22723kB time=00:01:00.01 bitrate=3101.8kbits/s    
frame= 1509 fps= 17 q=15.0 size=   22912kB time=00:01:00.45 bitrate=3104.5kbits/s    
frame= 1522 fps= 17 q=17.0 size=   23104kB time=00:01:00.97 bitrate=3104.3kbits/s    
frame= 1536 fps= 17 q=17.0 size=   23274kB time=00:01:01.52 bitrate=3098.8kbits/s    
frame= 1549 fps= 18 q=15.0 size=   23436kB time=00:01:02.05 bitrate=3093.6kbits/s    
frame= 1555 fps= 17 q=16.0 size=   23566kB time=00:01:02.29 bitrate=3099.1kbits/s    
frame= 1566 fps= 18 q=15.0 size=   23838kB time=00:01:02.72 bitrate=3113.5kbits/s    
frame= 1577 fps= 18 q=16.0 size=   24059kB time=00:01:03.16 bitrate=3120.1kbits/s    
frame= 1591 fps= 18 q=17.0 size=   24209kB time=00:01:03.72 bitrate=3112.2kbits/s    
frame= 1601 fps= 18 q=16.0 size=   24319kB time=00:01:04.12 bitrate=3106.6kbits/s    
frame= 1611 fps= 18 q=16.0 size=   24533kB time=00:01:04.53 bitrate=3114.2kbits/s    
frame= 1621 fps= 18 q=16.0 size=   24646kB time=00:01:04.93 bitrate=3109.1kbits/s    
frame= 1629 fps= 18 q=10.0 size=   24732kB time=00:01:05.25 bitrate=3104.6kbits/s    
frame= 1637 fps= 18 q=18.0 size=   24991kB time=00:01:05.57 bitrate=3121.8kbits/s    
frame= 1645 fps= 18 q=18.0 size=   25117kB time=00:01:05.89 bitrate=3122.4kbits/s    
frame= 1652 fps= 18 q=18.0 size=   25189kB time=00:01:06.17 bitrate=3118.2kbits/s    
frame= 1655 fps= 17 q=18.0 size=   25256kB time=00:01:06.28 bitrate=3121.4kbits/s    
frame= 1664 fps= 17 q=21.0 size=   25366kB time=00:01:06.64 bitrate=3118.0kbits/s    
frame= 1672 fps= 17 q=23.0 size=   25595kB time=00:01:06.96 bitrate=3131.1kbits/s    
frame= 1679 fps= 17 q=20.0 size=   25706kB time=00:01:07.24 bitrate=3131.7kbits/s    
frame= 1684 fps= 17 q=19.0 size=   25780kB time=00:01:07.45 bitrate=3130.8kbits/s    
frame= 1691 fps= 17 q=19.0 size=   25921kB time=00:01:07.73 bitrate=3135.0kbits/s    
frame= 1698 fps= 17 q=19.0 size=   26040kB time=00:01:08.01 bitrate=3136.6kbits/s    
frame= 1707 fps= 17 q=21.0 size=   26302kB time=00:01:08.37 bitrate=3151.3kbits/s    
frame= 1716 fps= 17 q=22.0 size=   26397kB time=00:01:08.73 bitrate=3146.0kbits/s    
frame= 1723 fps= 17 q=20.0 size=   26480kB time=00:01:09.01 bitrate=3143.2kbits/s    
frame= 1728 fps= 17 q=21.0 size=   26510kB time=00:01:09.20 bitrate=3138.0kbits/s    
frame= 1732 fps= 17 q=20.0 size=   26534kB time=00:01:09.37 bitrate=3133.1kbits/s    
frame= 1738 fps= 17 q=20.0 size=   26597kB time=00:01:09.61 bitrate=3130.0kbits/s    
frame= 1746 fps= 17 q=20.0 size=   26686kB time=00:01:09.93 bitrate=3126.1kbits/s    
frame= 1753 fps= 17 q=20.0 size=   26797kB time=00:01:10.20 bitrate=3126.7kbits/s    
frame= 1761 fps= 17 q=20.0 size=   26898kB time=00:01:10.52 bitrate=3124.3kbits/s    
frame= 1765 fps= 17 q=21.0 size=   26967kB time=00:01:10.69 bitrate=3124.7kbits/s    
frame= 1770 fps= 17 q=20.0 size=   27036kB time=00:01:10.89 bitrate=3124.3kbits/s    
frame= 1773 fps= 17 q=20.0 size=   27080kB time=00:01:11.01 bitrate=3123.7kbits/s    
frame= 1777 fps= 17 q=20.0 size=   27353kB time=00:01:11.16 bitrate=3148.5kbits/s    
frame= 1779 fps= 17 q=21.0 size=   27391kB time=00:01:11.25 bitrate=3149.1kbits/s    
frame= 1782 fps= 17 q=21.0 size=   27410kB time=00:01:11.36 bitrate=3146.7kbits/s    
frame= 1785 fps= 17 q=21.0 size=   27445kB time=00:01:11.48 bitrate=3145.0kbits/s    
frame= 1792 fps= 17 q=21.0 size=   27535kB time=00:01:11.76 bitrate=3143.1kbits/s    
frame= 1799 fps= 17 q=22.0 size=   27578kB time=00:01:12.04 bitrate=3135.9kbits/s    
frame= 1804 fps= 17 q=22.0 size=   27707kB time=00:01:12.25 bitrate=3141.3kbits/s    
frame= 1812 fps= 16 q=22.0 size=   27776kB time=00:01:12.57 bitrate=3135.2kbits/s    
frame= 1818 fps= 16 q=22.0 size=   27894kB time=00:01:12.81 bitrate=3138.4kbits/s    
frame= 1823 fps= 16 q=22.0 size=   28033kB time=00:01:13.00 bitrate=3145.7kbits/s    
frame= 1831 fps= 16 q=24.0 size=   28136kB time=00:01:13.32 bitrate=3143.5kbits/s    
frame= 1837 fps= 16 q=24.0 size=   28250kB time=00:01:13.57 bitrate=3145.3kbits/s    
frame= 1840 fps= 16 q=24.0 size=   28315kB time=00:01:13.68 bitrate=3148.0kbits/s    
frame= 1843 fps= 16 q=23.0 size=   28362kB time=00:01:13.81 bitrate=3147.6kbits/s    
frame= 1849 fps= 16 q=23.0 size=   28610kB time=00:01:14.04 bitrate=3165.2kbits/s    
frame= 1855 fps= 16 q=23.0 size=   28675kB time=00:01:14.28 bitrate=3162.3kbits/s    
frame= 1862 fps= 16 q=24.0 size=   28761kB time=00:01:14.56 bitrate=3160.0kbits/s    
frame= 1869 fps= 16 q=23.0 size=   28830kB time=00:01:14.85 bitrate=3155.0kbits/s    
frame= 1875 fps= 16 q=21.0 size=   28857kB time=00:01:15.09 bitrate=3148.1kbits/s    
frame= 1877 fps= 16 q=21.0 size=   28968kB time=00:01:15.17 bitrate=3156.5kbits/s    
frame= 1883 fps= 16 q=22.0 size=   29037kB time=00:01:15.41 bitrate=3154.2kbits/s    
frame= 1888 fps= 16 q=22.0 size=   29104kB time=00:01:15.60 bitrate=3153.5kbits/s    
frame= 1891 fps= 16 q=22.0 size=   29170kB time=00:01:15.73 bitrate=3155.3kbits/s    
frame= 1895 fps= 16 q=22.0 size=   29216kB time=00:01:15.88 bitrate=3154.0kbits/s    
frame= 1900 fps= 16 q=22.0 size=   29314kB time=00:01:16.09 bitrate=3155.7kbits/s    
frame= 1909 fps= 16 q=22.0 size=   29434kB time=00:01:16.45 bitrate=3153.6kbits/s    
frame= 1918 fps= 16 q=19.0 size=   29521kB time=00:01:16.80 bitrate=3148.9kbits/s    
frame= 1931 fps= 16 q=18.0 size=   29820kB time=00:01:17.33 bitrate=3158.9kbits/s    
frame= 1942 fps= 16 q=18.0 size=   30040kB time=00:01:17.76 bitrate=3164.7kbits/s    
frame= 1954 fps= 16 q=18.0 size=   30180kB time=00:01:18.25 bitrate=3159.5kbits/s    
frame= 1964 fps= 16 q=18.0 size=   30301kB time=00:01:18.65 bitrate=3155.9kbits/s    
frame= 1973 fps= 16 q=16.0 size=   30425kB time=00:01:19.01 bitrate=3154.2kbits/s    
frame= 1979 fps= 16 q=19.0 size=   30507kB time=00:01:19.25 bitrate=3153.4kbits/s    
frame= 1984 fps= 16 q=18.0 size=   30551kB time=00:01:19.44 bitrate=3150.3kbits/s    
frame= 1987 fps= 16 q=17.0 size=   30598kB time=00:01:19.57 bitrate=3150.1kbits/s    
frame= 1991 fps= 16 q=21.0 size=   30621kB time=00:01:19.72 bitrate=3146.5kbits/s    
frame= 1997 fps= 16 q=20.0 size=   30846kB time=00:01:19.97 bitrate=3159.5kbits/s    
frame= 2003 fps= 16 q=18.0 size=   30901kB time=00:01:20.21 bitrate=3155.8kbits/s    
frame= 2009 fps= 16 q=16.0 size=   30952kB time=00:01:20.44 bitrate=3151.8kbits/s    
frame= 2015 fps= 16 q=14.0 size=   31029kB time=00:01:20.68 bitrate=3150.4kbits/s    
frame= 2023 fps= 16 q=9.0 size=   31146kB time=00:01:21.00 bitrate=3149.9kbits/s    
frame= 2030 fps= 16 q=20.0 size=   31347kB time=00:01:21.28 bitrate=3159.4kbits/s    
frame= 2040 fps= 16 q=20.0 size=   31499kB time=00:01:21.68 bitrate=3158.9kbits/s    
frame= 2046 fps= 16 q=20.0 size=   31596kB time=00:01:21.92 bitrate=3159.6kbits/s    
frame= 2052 fps= 16 q=18.0 size=   31704kB time=00:01:22.17 bitrate=3160.5kbits/s    
frame= 2059 fps= 16 q=20.0 size=   31818kB time=00:01:22.45 bitrate=3161.3kbits/s    
frame= 2070 fps= 16 q=19.0 size=   32158kB time=00:01:22.88 bitrate=3178.5kbits/s    
frame= 2081 fps= 16 q=19.0 size=   32274kB time=00:01:23.32 bitrate=3172.9kbits/s    
frame= 2091 fps= 16 q=16.0 size=   32352kB time=00:01:23.73 bitrate=3165.1kbits/s    
frame= 2101 fps= 16 q=17.0 size=   32504kB time=00:01:24.13 bitrate=3164.7kbits/s    
frame= 2110 fps= 16 q=18.0 size=   32558kB time=00:01:24.48 bitrate=3157.2kbits/s    
frame= 2117 fps= 16 q=15.0 size=   32665kB time=00:01:24.77 bitrate=3156.4kbits/s    
frame= 2129 fps= 16 q=18.0 size=   32815kB time=00:01:25.24 bitrate=3153.4kbits/s    
frame= 2140 fps= 16 q=19.0 size=   33269kB time=00:01:25.69 bitrate=3180.3kbits/s    
frame= 2152 fps= 16 q=18.0 size=   33378kB time=00:01:26.16 bitrate=3173.4kbits/s    
frame= 2161 fps= 16 q=19.0 size=   33571kB time=00:01:26.52 bitrate=3178.3kbits/s    
frame= 2174 fps= 16 q=19.0 size=   33677kB time=00:01:27.04 bitrate=3169.6kbits/s    
frame= 2185 fps= 16 q=19.0 size=   33808kB time=00:01:27.48 bitrate=3165.6kbits/s    
frame= 2195 fps= 16 q=18.0 size=   33965kB time=00:01:27.89 bitrate=3165.6kbits/s    
frame= 2204 fps= 16 q=18.0 size=   34156kB time=00:01:28.25 bitrate=3170.4kbits/s    
frame= 2215 fps= 16 q=20.0 size=   34492kB time=00:01:28.68 bitrate=3186.2kbits/s    
frame= 2220 fps= 16 q=20.0 size=   34543kB time=00:01:28.89 bitrate=3183.2kbits/s    
frame= 2228 fps= 16 q=19.0 size=   34673kB time=00:01:29.21 bitrate=3183.8kbits/s    
frame= 2239 fps= 16 q=20.0 size=   34841kB time=00:01:29.64 bitrate=3183.9kbits/s    
frame= 2250 fps= 16 q=19.0 size=   34960kB time=00:01:30.09 bitrate=3179.0kbits/s    
frame= 2258 fps= 16 q=19.0 size=   35107kB time=00:01:30.41 bitrate=3181.0kbits/s    
frame= 2266 fps= 16 q=19.0 size=   35248kB time=00:01:30.73 bitrate=3182.5kbits/s    
frame= 2274 fps= 16 q=19.0 size=   35418kB time=00:01:31.05 bitrate=3186.6kbits/s    
frame= 2288 fps= 16 q=21.0 size=   35653kB time=00:01:31.60 bitrate=3188.3kbits/s    
frame= 2300 fps= 16 q=20.0 size=   35783kB time=00:01:32.09 bitrate=3182.9kbits/s    
frame= 2310 fps= 16 q=20.0 size=   35928kB time=00:01:32.48 bitrate=3182.5kbits/s    
frame= 2317 fps= 16 q=20.0 size=   36044kB time=00:01:32.77 bitrate=3182.6kbits/s    
frame= 2325 fps= 16 q=21.0 size=   36141kB time=00:01:33.09 bitrate=3180.1kbits/s    
frame= 2336 fps= 16 q=21.0 size=   36283kB time=00:01:33.52 bitrate=3178.1kbits/s    
frame= 2346 fps= 16 q=20.0 size=   36400kB time=00:01:33.93 bitrate=3174.6kbits/s    
frame= 2356 fps= 16 q=20.0 size=   36791kB time=00:01:34.33 bitrate=3194.9kbits/s    
frame= 2364 fps= 16 q=20.0 size=   36919kB time=00:01:34.65 bitrate=3195.2kbits/s    
frame= 2372 fps= 16 q=20.0 size=   37059kB time=00:01:34.97 bitrate=3196.5kbits/s    
frame= 2381 fps= 16 q=20.0 size=   37156kB time=00:01:35.33 bitrate=3192.6kbits/s    
frame= 2391 fps= 16 q=21.0 size=   37258kB time=00:01:35.72 bitrate=3188.5kbits/s    
frame= 2398 fps= 16 q=21.0 size=   37323kB time=00:01:36.00 bitrate=3184.9kbits/s    
frame= 2404 fps= 16 q=21.0 size=   37384kB time=00:01:36.25 bitrate=3181.6kbits/s    
frame= 2409 fps= 16 q=20.0 size=   37418kB time=00:01:36.44 bitrate=3178.2kbits/s    
frame= 2416 fps= 16 q=19.0 size=   37556kB time=00:01:36.72 bitrate=3180.7kbits/s    
frame= 2424 fps= 16 q=20.0 size=   37857kB time=00:01:37.04 bitrate=3195.7kbits/s    
frame= 2433 fps= 16 q=20.0 size=   38001kB time=00:01:37.40 bitrate=3195.9kbits/s    
frame= 2440 fps= 16 q=20.0 size=   38128kB time=00:01:37.68 bitrate=3197.5kbits/s    
frame= 2449 fps= 16 q=18.0 size=   38283kB time=00:01:38.04 bitrate=3198.6kbits/s    
frame= 2459 fps= 16 q=20.0 size=   38476kB time=00:01:38.45 bitrate=3201.5kbits/s    
frame= 2471 fps= 16 q=18.0 size=   38560kB time=00:01:38.92 bitrate=3193.3kbits/s    
frame= 2481 fps= 16 q=19.0 size=   38715kB time=00:01:39.32 bitrate=3193.0kbits/s    
frame= 2496 fps= 16 q=19.0 size=   39116kB time=00:01:39.92 bitrate=3206.7kbits/s    
frame= 2506 fps= 16 q=19.0 size=   39167kB time=00:01:40.33 bitrate=3198.0kbits/s    
frame= 2515 fps= 16 q=14.0 size=   39418kB time=00:01:40.69 bitrate=3206.9kbits/s    
frame= 2528 fps= 16 q=17.0 size=   39611kB time=00:01:41.20 bitrate=3206.3kbits/s    
frame= 2542 fps= 16 q=16.0 size=   39728kB time=00:01:41.76 bitrate=3198.2kbits/s    
frame= 2555 fps= 16 q=14.0 size=   39853kB time=00:01:42.29 bitrate=3191.6kbits/s    
frame= 2568 fps= 16 q=20.0 size=   40220kB time=00:01:42.80 bitrate=3204.9kbits/s    
frame= 2583 fps= 16 q=16.0 size=   40437kB time=00:01:43.40 bitrate=3203.6kbits/s    
frame= 2595 fps= 16 q=17.0 size=   40564kB time=00:01:43.89 bitrate=3198.5kbits/s    
frame= 2607 fps= 16 q=19.0 size=   40688kB time=00:01:44.36 bitrate=3193.8kbits/s    
frame= 2618 fps= 16 q=19.0 size=   40817kB time=00:01:44.81 bitrate=3190.2kbits/s    
frame= 2625 fps= 16 q=20.0 size=   40922kB time=00:01:45.08 bitrate=3190.0kbits/s    
frame= 2631 fps= 16 q=17.0 size=   40974kB time=00:01:45.32 bitrate=3186.9kbits/s    
frame= 2640 fps= 16 q=22.0 size=   41341kB time=00:01:45.68 bitrate=3204.4kbits/s    
frame= 2647 fps= 16 q=20.0 size=   41411kB time=00:01:45.96 bitrate=3201.5kbits/s    
frame= 2654 fps= 16 q=20.0 size=   41543kB time=00:01:46.24 bitrate=3203.3kbits/s    
frame= 2662 fps= 16 q=20.0 size=   41654kB time=00:01:46.56 bitrate=3202.2kbits/s    
frame= 2674 fps= 16 q=20.0 size=   41795kB time=00:01:47.05 bitrate=3198.3kbits/s    
frame= 2683 fps= 16 q=20.0 size=   41982kB time=00:01:47.41 bitrate=3201.8kbits/s    
frame= 2693 fps= 16 q=21.0 size=   42163kB time=00:01:47.81 bitrate=3203.5kbits/s    
frame= 2702 fps= 16 q=19.0 size=   42347kB time=00:01:48.16 bitrate=3207.3kbits/s    
frame= 2709 fps= 16 q=20.0 size=   42452kB time=00:01:48.45 bitrate=3206.4kbits/s    
frame= 2717 fps= 16 q=23.0 size=   42640kB time=00:01:48.77 bitrate=3211.2kbits/s    
frame= 2727 fps= 16 q=21.0 size=   42740kB time=00:01:49.16 bitrate=3207.3kbits/s    
frame= 2738 fps= 16 q=18.0 size=   42890kB time=00:01:49.61 bitrate=3205.5kbits/s    
frame= 2752 fps= 16 q=19.0 size=   42979kB time=00:01:50.16 bitrate=3195.9kbits/s    
frame= 2764 fps= 16 q=16.0 size=   43217kB time=00:01:50.65 bitrate=3199.4kbits/s    
frame= 2777 fps= 16 q=13.0 size=   43368kB time=00:01:51.16 bitrate=3195.8kbits/s    
frame= 2793 fps= 16 q=15.0 size=   43750kB time=00:01:51.80 bitrate=3205.5kbits/s    
frame= 2809 fps= 16 q=11.0 size=   43828kB time=00:01:52.44 bitrate=3193.0kbits/s    
frame= 2820 fps= 16 q=12.0 size=   43996kB time=00:01:52.89 bitrate=3192.5kbits/s    
frame= 2830 fps= 16 q=10.0 size=   44159kB time=00:01:53.28 bitrate=3193.4kbits/s    
frame= 2839 fps= 16 q=15.0 size=   44238kB time=00:01:53.64 bitrate=3188.9kbits/s    
frame= 2850 fps= 16 q=16.0 size=   44374kB time=00:01:54.09 bitrate=3186.2kbits/s    
frame= 2866 fps= 16 q=17.0 size=   44756kB time=00:01:54.73 bitrate=3195.7kbits/s    
frame= 2877 fps= 16 q=17.0 size=   44989kB time=00:01:55.17 bitrate=3199.8kbits/s    
frame= 2888 fps= 16 q=18.0 size=   45129kB time=00:01:55.60 bitrate=3197.9kbits/s    
frame= 2896 fps= 16 q=17.0 size=   45319kB time=00:01:55.92 bitrate=3202.5kbits/s    
frame= 2908 fps= 16 q=19.0 size=   45443kB time=00:01:56.41 bitrate=3197.8kbits/s    
frame= 2918 fps= 16 q=18.0 size=   45555kB time=00:01:56.80 bitrate=3195.1kbits/s    
frame= 2930 fps= 16 q=19.0 size=   45805kB time=00:01:57.29 bitrate=3199.2kbits/s    
frame= 2939 fps= 16 q=18.0 size=   46043kB time=00:01:57.65 bitrate=3205.9kbits/s    
frame= 2946 fps= 16 q=18.0 size=   46118kB time=00:01:57.93 bitrate=3203.6kbits/s    
frame= 2954 fps= 16 q=18.0 size=   46303kB time=00:01:58.25 bitrate=3207.7kbits/s    
frame= 2966 fps= 16 q=19.0 size=   46495kB time=00:01:58.72 bitrate=3208.3kbits/s    
frame= 2980 fps= 16 q=20.0 size=   46656kB time=00:01:59.29 bitrate=3203.8kbits/s    
frame= 2994 fps= 16 q=18.0 size=   46831kB time=00:01:59.85 bitrate=3201.0kbits/s    
frame= 3007 fps= 17 q=18.0 size=   47172kB time=00:02:00.36 bitrate=3210.6kbits/s    
frame= 3016 fps= 17 q=13.0 size=   47289kB time=00:02:00.72 bitrate=3208.8kbits/s    
frame= 3033 fps= 17 q=12.0 size=   47401kB time=00:02:01.40 bitrate=3198.4kbits/s    
frame= 3048 fps= 17 q=14.0 size=   47627kB time=00:02:02.00 bitrate=3197.9kbits/s    
frame= 3056 fps= 17 q=21.0 size=   47814kB time=00:02:02.32 bitrate=3202.1kbits/s    
frame= 3063 fps= 17 q=20.0 size=   47858kB time=00:02:02.60 bitrate=3197.8kbits/s    
frame= 3071 fps= 17 q=19.0 size=   47978kB time=00:02:02.92 bitrate=3197.4kbits/s    
frame= 3083 fps= 17 q=18.0 size=   48334kB time=00:02:03.41 bitrate=3208.3kbits/s    
frame= 3094 fps= 17 q=16.0 size=   48529kB time=00:02:03.84 bitrate=3210.2kbits/s    
frame= 3106 fps= 17 q=13.0 size=   48716kB time=00:02:04.33 bitrate=3209.8kbits/s    
frame= 3121 fps= 17 q=11.0 size=   48853kB time=00:02:04.92 bitrate=3203.5kbits/s    
frame= 3137 fps= 17 q=9.0 size=   49016kB time=00:02:05.56 bitrate=3197.8kbits/s    
frame= 3153 fps= 17 q=9.0 size=   49368kB time=00:02:06.20 bitrate=3204.4kbits/s    
frame= 3172 fps= 17 q=9.0 size=   49563kB time=00:02:06.97 bitrate=3197.6kbits/s    
frame= 3189 fps= 17 q=11.0 size=   49774kB time=00:02:07.65 bitrate=3194.1kbits/s    
frame= 3200 fps= 17 q=14.0 size=   50028kB time=00:02:08.08 bitrate=3199.7kbits/s    
frame= 3206 fps= 17 q=14.0 size=   50063kB time=00:02:08.32 bitrate=3196.0kbits/s    
frame= 3215 fps= 17 q=15.0 size=   50200kB time=00:02:08.68 bitrate=3195.8kbits/s    
frame= 3228 fps= 17 q=18.0 size=   50512kB time=00:02:09.21 bitrate=3202.3kbits/s    
frame= 3240 fps= 17 q=19.0 size=   50642kB time=00:02:09.68 bitrate=3199.0kbits/s    
frame= 3248 fps= 17 q=19.0 size=   50751kB time=00:02:10.00 bitrate=3197.9kbits/s    
frame= 3253 fps= 17 q=9.0 size=   50823kB time=00:02:10.21 bitrate=3197.3kbits/s    
frame= 3260 fps= 17 q=21.0 size=   51032kB time=00:02:10.49 bitrate=3203.6kbits/s    
frame= 3268 fps= 17 q=22.0 size=   51196kB time=00:02:10.81 bitrate=3206.0kbits/s    
frame= 3278 fps= 17 q=22.0 size=   51360kB time=00:02:11.20 bitrate=3206.8kbits/s    
frame= 3286 fps= 17 q=19.0 size=   51484kB time=00:02:11.52 bitrate=3206.8kbits/s    
frame= 3295 fps= 17 q=22.0 size=   51741kB time=00:02:11.88 bitrate=3213.9kbits/s    
frame= 3301 fps= 17 q=21.0 size=   51900kB time=00:02:12.13 bitrate=3217.6kbits/s    
frame= 3313 fps= 17 q=18.0 size=   52014kB time=00:02:12.60 bitrate=3213.2kbits/s    
frame= 3326 fps= 17 q=19.0 size=   52158kB time=00:02:13.12 bitrate=3209.7kbits/s    
frame= 3339 fps= 17 q=18.0 size=   52286kB time=00:02:13.65 bitrate=3204.8kbits/s    
frame= 3347 fps= 17 q=17.0 size=   52395kB time=00:02:13.97 bitrate=3203.8kbits/s    
frame= 3356 fps= 17 q=18.0 size=   52512kB time=00:02:14.33 bitrate=3202.3kbits/s    
frame= 3368 fps= 17 q=20.0 size=   52878kB time=00:02:14.80 bitrate=3213.3kbits/s    
frame= 3380 fps= 17 q=22.0 size=   53081kB time=00:02:15.29 bitrate=3214.0kbits/s    
frame= 3391 fps= 17 q=23.0 size=   53237kB time=00:02:15.72 bitrate=3213.3kbits/s    
frame= 3398 fps= 17 q=23.0 size=   53335kB time=00:02:16.00 bitrate=3212.7kbits/s    
frame= 3407 fps= 17 q=23.0 size=   53463kB time=00:02:16.36 bitrate=3211.8kbits/s    
frame= 3417 fps= 17 q=22.0 size=   53622kB time=00:02:16.76 bitrate=3211.8kbits/s    
frame= 3427 fps= 17 q=23.0 size=   53786kB time=00:02:17.17 bitrate=3212.1kbits/s    
frame= 3440 fps= 17 q=23.0 size=   54107kB time=00:02:17.68 bitrate=3219.2kbits/s    
frame= 3452 fps= 17 q=21.0 size=   54275kB time=00:02:18.17 bitrate=3217.8kbits/s    
frame= 3463 fps= 17 q=21.0 size=   54441kB time=00:02:18.60 bitrate=3217.7kbits/s    
frame= 3474 fps= 17 q=21.0 size=   54623kB time=00:02:19.05 bitrate=3218.1kbits/s    
frame= 3483 fps= 17 q=22.0 size=   54844kB time=00:02:19.41 bitrate=3222.6kbits/s    
frame= 3499 fps= 17 q=20.0 size=   54926kB time=00:02:20.05 bitrate=3212.7kbits/s    
frame= 3509 fps= 17 q=21.0 size=   55043kB time=00:02:20.45 bitrate=3210.3kbits/s    
frame= 3514 fps= 17 q=22.0 size=   55133kB time=00:02:20.65 bitrate=3211.1kbits/s    
frame= 3522 fps= 17 q=22.0 size=   55313kB time=00:02:20.97 bitrate=3214.3kbits/s    
frame= 3531 fps= 17 q=21.0 size=   55485kB time=00:02:21.33 bitrate=3216.0kbits/s    
frame= 3537 fps= 17 q=22.0 size=   55615kB time=00:02:21.56 bitrate=3218.2kbits/s    
frame= 3543 fps= 17 q=21.0 size=   55719kB time=00:02:21.80 bitrate=3218.9kbits/s    
frame= 3548 fps= 17 q=21.0 size=   55779kB time=00:02:22.01 bitrate=3217.6kbits/s    
frame= 3553 fps= 17 q=21.0 size=   55901kB time=00:02:22.20 bitrate=3220.2kbits/s    
frame= 3560 fps= 17 q=20.0 size=   55995kB time=00:02:22.48 bitrate=3219.3kbits/s    
frame= 3566 fps= 17 q=19.0 size=   56128kB time=00:02:22.72 bitrate=3221.7kbits/s    
frame= 3574 fps= 17 q=17.0 size=   56242kB time=00:02:23.04 bitrate=3221.0kbits/s    
frame= 3579 fps= 17 q=18.0 size=   56403kB time=00:02:23.25 bitrate=3225.4kbits/s    
frame= 3585 fps= 17 q=19.0 size=   56447kB time=00:02:23.48 bitrate=3222.7kbits/s    
frame= 3592 fps= 17 q=13.0 size=   56617kB time=00:02:23.76 bitrate=3226.1kbits/s    
frame= 3604 fps= 17 q=7.0 size=   56702kB time=00:02:24.25 bitrate=3220.0kbits/s    
frame= 3617 fps= 17 q=11.0 size=   56821kB time=00:02:24.76 bitrate=3215.3kbits/s    
frame= 3627 fps= 17 q=9.0 size=   56911kB time=00:02:25.17 bitrate=3211.5kbits/s    
frame= 3638 fps= 17 q=8.0 size=   57021kB time=00:02:25.60 bitrate=3208.2kbits/s    
frame= 3648 fps= 17 q=18.0 size=   57225kB time=00:02:26.00 bitrate=3210.7kbits/s    
frame= 3659 fps= 17 q=17.0 size=   57251kB time=00:02:26.45 bitrate=3202.4kbits/s    
frame= 3662 fps= 17 q=18.0 size=   57362kB time=00:02:26.56 bitrate=3206.3kbits/s    
frame= 3666 fps= 17 q=20.0 size=   57461kB time=00:02:26.73 bitrate=3208.1kbits/s    
frame= 3668 fps= 17 q=21.0 size=   57516kB time=00:02:26.81 bitrate=3209.3kbits/s    
frame= 3670 fps= 17 q=21.0 size=   57569kB time=00:02:26.88 bitrate=3210.8kbits/s    
frame= 3674 fps= 17 q=21.0 size=   57666kB time=00:02:27.05 bitrate=3212.5kbits/s    
frame= 3680 fps= 17 q=21.0 size=   57794kB time=00:02:27.28 bitrate=3214.5kbits/s    
frame= 3684 fps= 17 q=21.0 size=   57863kB time=00:02:27.45 bitrate=3214.6kbits/s    
frame= 3689 fps= 17 q=20.0 size=   57952kB time=00:02:27.64 bitrate=3215.4kbits/s    
frame= 3693 fps= 17 q=20.0 size=   58041kB time=00:02:27.81 bitrate=3216.6kbits/s    
frame= 3699 fps= 17 q=21.0 size=   58150kB time=00:02:28.05 bitrate=3217.5kbits/s    
frame= 3707 fps= 17 q=22.0 size=   58226kB time=00:02:28.37 bitrate=3214.8kbits/s    
frame= 3715 fps= 17 q=22.0 size=   58319kB time=00:02:28.69 bitrate=3213.0kbits/s    
frame= 3718 fps= 17 q=18.0 size=   58347kB time=00:02:28.80 bitrate=3212.2kbits/s    
frame= 3722 fps= 17 q=20.0 size=   58514kB time=00:02:28.97 bitrate=3217.7kbits/s    
frame= 3726 fps= 16 q=21.0 size=   58556kB time=00:02:29.12 bitrate=3216.8kbits/s    
frame= 3731 fps= 16 q=22.0 size=   58613kB time=00:02:29.33 bitrate=3215.3kbits/s    
frame= 3738 fps= 16 q=20.0 size=   58682kB time=00:02:29.61 bitrate=3213.1kbits/s    
frame= 3743 fps= 16 q=21.0 size=   58773kB time=00:02:29.80 bitrate=3214.0kbits/s    
frame= 3748 fps= 16 q=19.0 size=   58871kB time=00:02:30.01 bitrate=3214.8kbits/s    
frame= 3752 fps= 16 q=22.0 size=   58986kB time=00:02:30.16 bitrate=3217.9kbits/s    
frame= 3756 fps= 16 q=21.0 size=   59079kB time=00:02:30.33 bitrate=3219.3kbits/s    
frame= 3759 fps= 16 q=22.0 size=   59156kB time=00:02:30.44 bitrate=3221.2kbits/s    
frame= 3765 fps= 16 q=21.0 size=   59274kB time=00:02:30.69 bitrate=3222.1kbits/s    
frame= 3769 fps= 16 q=20.0 size=   59344kB time=00:02:30.84 bitrate=3222.7kbits/s    
frame= 3773 fps= 16 q=19.0 size=   59397kB time=00:02:31.01 bitrate=3222.0kbits/s    
frame= 3778 fps= 16 q=17.0 size=   59516kB time=00:02:31.21 bitrate=3224.4kbits/s    
frame= 3786 fps= 16 q=18.0 size=   59558kB time=00:02:31.53 bitrate=3219.8kbits/s    
frame= 3794 fps= 16 q=18.0 size=   59748kB time=00:02:31.85 bitrate=3223.3kbits/s    
frame= 3801 fps= 16 q=17.0 size=   59804kB time=00:02:32.12 bitrate=3220.4kbits/s    
frame= 3810 fps= 16 q=17.0 size=   59852kB time=00:02:32.49 bitrate=3215.3kbits/s    
frame= 3817 fps= 16 q=14.0 size=   59926kB time=00:02:32.76 bitrate=3213.5kbits/s    
frame= 3821 fps= 16 q=16.0 size=   60014kB time=00:02:32.93 bitrate=3214.6kbits/s    
frame= 3827 fps= 16 q=15.0 size=   60143kB time=00:02:33.17 bitrate=3216.5kbits/s    
frame= 3831 fps= 16 q=17.0 size=   60197kB time=00:02:33.32 bitrate=3216.3kbits/s    
frame= 3835 fps= 16 q=15.0 size=   60234kB time=00:02:33.49 bitrate=3214.7kbits/s    
frame= 3841 fps= 16 q=16.0 size=   60292kB time=00:02:33.72 bitrate=3212.9kbits/s    
frame= 3851 fps= 16 q=20.0 size=   60444kB time=00:02:34.13 bitrate=3212.5kbits/s    
frame= 3862 fps= 16 q=16.0 size=   60586kB time=00:02:34.56 bitrate=3211.2kbits/s    
frame= 3873 fps= 16 q=19.0 size=   60878kB time=00:02:35.00 bitrate=3217.4kbits/s    
frame= 3885 fps= 16 q=17.0 size=   61002kB time=00:02:35.49 bitrate=3213.7kbits/s    
frame= 3890 fps= 16 q=17.0 size=   61129kB time=00:02:35.69 bitrate=3216.4kbits/s    
frame= 3897 fps= 16 q=18.0 size=   61326kB time=00:02:35.96 bitrate=3221.1kbits/s    
frame= 3905 fps= 16 q=19.0 size=   61424kB time=00:02:36.28 bitrate=3219.6kbits/s    
frame= 3916 fps= 16 q=18.0 size=   61504kB time=00:02:36.73 bitrate=3214.6kbits/s    
frame= 3923 fps= 16 q=18.0 size=   61608kB time=00:02:37.01 bitrate=3214.3kbits/s    
frame= 3933 fps= 16 q=18.0 size=   61722kB time=00:02:37.41 bitrate=3212.0kbits/s    
frame= 3945 fps= 16 q=16.0 size=   62088kB time=00:02:37.88 bitrate=3221.4kbits/s    
frame= 3955 fps= 16 q=12.0 size=   62148kB time=00:02:38.29 bitrate=3216.3kbits/s    
frame= 3964 fps= 16 q=13.0 size=   62355kB time=00:02:38.65 bitrate=3219.6kbits/s    
frame= 3979 fps= 16 q=9.0 size=   62460kB time=00:02:39.25 bitrate=3212.9kbits/s    
frame= 3994 fps= 16 q=11.0 size=   62691kB time=00:02:39.85 bitrate=3212.8kbits/s    
frame= 4006 fps= 16 q=16.0 size=   62865kB time=00:02:40.32 bitrate=3212.3kbits/s    
frame= 4012 fps= 16 q=17.0 size=   63095kB time=00:02:40.57 bitrate=3218.9kbits/s    
frame= 4024 fps= 16 q=17.0 size=   63328kB time=00:02:41.04 bitrate=3221.4kbits/s    
frame= 4035 fps= 16 q=17.0 size=   63506kB time=00:02:41.49 bitrate=3221.4kbits/s    
frame= 4045 fps= 16 q=18.0 size=   63698kB time=00:02:41.89 bitrate=3223.1kbits/s    
frame= 4061 fps= 16 q=18.0 size=   63780kB time=00:02:42.53 bitrate=3214.5kbits/s    
frame= 4073 fps= 16 q=19.0 size=   63940kB time=00:02:43.00 bitrate=3213.3kbits/s    
frame= 4083 fps= 16 q=21.0 size=   64226kB time=00:02:43.41 bitrate=3219.7kbits/s    
frame= 4091 fps= 16 q=22.0 size=   64374kB time=00:02:43.73 bitrate=3220.8kbits/s    
frame= 4098 fps= 16 q=22.0 size=   64497kB time=00:02:44.01 bitrate=3221.5kbits/s    
frame= 4109 fps= 16 q=23.0 size=   64669kB time=00:02:44.45 bitrate=3221.3kbits/s    
frame= 4114 fps= 16 q=23.0 size=   64741kB time=00:02:44.65 bitrate=3221.1kbits/s    
frame= 4117 fps= 16 q=23.0 size=   64789kB time=00:02:44.77 bitrate=3221.0kbits/s    
frame= 4122 fps= 16 q=23.0 size=   64864kB time=00:02:44.97 bitrate=3221.0kbits/s    
frame= 4131 fps= 16 q=23.0 size=   65009kB time=00:02:45.33 bitrate=3221.1kbits/s    
frame= 4139 fps= 16 q=25.0 size=   65145kB time=00:02:45.65 bitrate=3221.6kbits/s    
frame= 4144 fps= 16 q=25.0 size=   65212kB time=00:02:45.84 bitrate=3221.2kbits/s    
frame= 4148 fps= 16 q=25.0 size=   65308kB time=00:02:46.01 bitrate=3222.6kbits/s    
frame= 4158 fps= 16 q=25.0 size=   65486kB time=00:02:46.40 bitrate=3223.9kbits/s    
frame= 4167 fps= 16 q=24.0 size=   65629kB time=00:02:46.76 bitrate=3223.9kbits/s    
frame= 4174 fps= 16 q=24.0 size=   65768kB time=00:02:47.04 bitrate=3225.4kbits/s    
frame= 4182 fps= 16 q=23.0 size=   65941kB time=00:02:47.36 bitrate=3227.7kbits/s    
frame= 4187 fps= 16 q=23.0 size=   66047kB time=00:02:47.57 bitrate=3228.8kbits/s    
frame= 4190 fps= 16 q=23.0 size=   66108kB time=00:02:47.68 bitrate=3229.7kbits/s    
frame= 4196 fps= 16 q=22.0 size=   66202kB time=00:02:47.93 bitrate=3229.4kbits/s    
frame= 4203 fps= 16 q=18.0 size=   66329kB time=00:02:48.21 bitrate=3230.2kbits/s    
frame= 4214 fps= 16 q=20.0 size=   66452kB time=00:02:48.64 bitrate=3228.0kbits/s    
frame= 4227 fps= 16 q=19.0 size=   66724kB time=00:02:49.17 bitrate=3231.0kbits/s    
frame= 4242 fps= 16 q=17.0 size=   66825kB time=00:02:49.77 bitrate=3224.5kbits/s    
frame= 4252 fps= 16 q=17.0 size=   66979kB time=00:02:50.17 bitrate=3224.3kbits/s    
frame= 4263 fps= 16 q=19.0 size=   67073kB time=00:02:50.60 bitrate=3220.7kbits/s    
frame= 4271 fps= 16 q=19.0 size=   67177kB time=00:02:50.85 bitrate=3220.9kbits/s    
frame= 4271 fps= 16 q=-1.0 Lsize=   68122kB time=00:02:50.85 bitrate=3266.2kbits/s    
video:59997kB audio:8008kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.171889%
[libx264 @ 0x19b2900] frame I:60    Avg QP: 8.68  size:180704
[libx264 @ 0x19b2900] frame P:2367  Avg QP:11.37  size: 18499
[libx264 @ 0x19b2900] frame B:1844  Avg QP:16.38  size:  3692
[libx264 @ 0x19b2900] consecutive B-frames: 41.7%  1.3%  3.2% 53.9%
[libx264 @ 0x19b2900] mb I  I16..4: 21.8%  0.0% 78.2%
[libx264 @ 0x19b2900] mb P  I16..4:  2.3%  0.0%  4.7%  P16..4: 23.6%  8.6%  5.5%  0.0%  0.0%    skip:55.4%
[libx264 @ 0x19b2900] mb B  I16..4:  0.1%  0.0%  0.6%  B16..8: 23.7%  3.1%  1.0%  direct: 1.6%  skip:69.9%  L0:49.3% L1:45.2% BI: 5.5%
[libx264 @ 0x19b2900] coded y,uvDC,uvAC intra: 74.0% 83.1% 62.6% inter: 9.5% 12.7% 3.5%
[libx264 @ 0x19b2900] i16 v,h,dc,p: 28% 32% 14% 26%
[libx264 @ 0x19b2900] i4 v,h,dc,ddl,ddr,vr,hd,vl,hu: 29% 22% 12%  5%  7%  7%  6%  7%  6%
[libx264 @ 0x19b2900] i8c dc,h,v,p: 41% 27% 20% 12%
[libx264 @ 0x19b2900] Weighted P-Frames: Y:0.0% UV:0.0%
[libx264 @ 0x19b2900] ref P L0: 83.9%  7.4%  7.2%  1.5%  0.0%
[libx264 @ 0x19b2900] ref B L0: 95.0%  4.5%  0.5%
[libx264 @ 0x19b2900] ref B L1: 96.6%  3.4%
[libx264 @ 0x19b2900] kb/s:2876.90