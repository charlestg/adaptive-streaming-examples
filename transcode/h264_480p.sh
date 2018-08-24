#!/bin/bash
# https://google.github.io/shaka-packager/html/tutorials/encoding.html
# Transcode h264_480p

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
       -vf "scale=-2:480" \
       -c:v libx264 -profile:v main -level:v 3.1 \
       -x264opts scenecut=0:open_gop=0:min-keyint=72:keyint=72 \
       -minrate 1000k -maxrate 1000k -bufsize 1000k -b:v 1000k \
       -y ${FILENAME}.t/h264_main_480p_1000.mp4
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
[libx264 @ 0xff8900] using SAR=1280/1281
[libx264 @ 0xff8900] using cpu capabilities: MMX2 SSE2Fast SSSE3 SSE4.2 AVX AVX2 FMA3 LZCNT BMI2
[libx264 @ 0xff8900] profile Main, level 3.1
[libx264 @ 0xff8900] 264 - core 142 r2495 6a301b6 - H.264/MPEG-4 AVC codec - Copyleft 2003-2014 - http://www.videolan.org/x264.html - options: cabac=1 ref=3 deblock=1:0:0 analyse=0x1:0x111 me=hex subme=7 psy=1 psy_rd=1.00:0.00 mixed_ref=1 me_range=16 chroma_me=1 trellis=1 8x8dct=0 cqm=0 deadzone=21,11 fast_pskip=1 chroma_qp_offset=-2 threads=3 lookahead_threads=1 sliced_threads=0 nr=0 decimate=1 interlaced=0 bluray_compat=0 constrained_intra=0 bframes=3 b_pyramid=2 b_adapt=1 b_bias=0 direct=1 weightb=1 open_gop=0 weightp=2 keyint=72 keyint_min=37 scenecut=0 intra_refresh=0 rc_lookahead=40 rc=cbr mbtree=1 bitrate=1000 ratetol=1.0 qcomp=0.60 qpmin=0 qpmax=69 qpstep=4 vbv_maxrate=1000 vbv_bufsize=1000 nal_hrd=none filler=0 ip_ratio=1.40 aq=1:1.00
[mp4 @ 0x1049f20] Codec for stream 1 does not use global headers but container format requires global headers
Output #0, mp4, to 'big_buck_bunny_720p_30mb.mp4.t/h264_main_480p_1000.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    encoder         : Lavf56.40.101
    Stream #0:0(und): Video: h264 (libx264) ([33][0][0][0] / 0x0021), yuv420p, 854x480 [SAR 1280:1281 DAR 16:9], q=-1--1, 1000 kb/s, 25 fps, 12800 tbn, 25 tbc (default)
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
frame=   60 fps= 51 q=28.0 size=      78kB time=00:00:02.49 bitrate= 256.4kbits/s    
frame=   70 fps= 38 q=30.0 size=     135kB time=00:00:02.88 bitrate= 382.8kbits/s    
frame=   77 fps= 33 q=28.0 size=     170kB time=00:00:03.17 bitrate= 438.5kbits/s    
frame=   91 fps= 32 q=29.0 size=     260kB time=00:00:03.73 bitrate= 569.7kbits/s    
frame=  107 fps= 31 q=29.0 size=     355kB time=00:00:04.37 bitrate= 665.7kbits/s    
frame=  115 fps= 29 q=28.0 size=     396kB time=00:00:04.69 bitrate= 690.4kbits/s    
frame=  133 fps= 30 q=25.0 size=     570kB time=00:00:05.41 bitrate= 862.0kbits/s    
frame=  155 fps= 31 q=27.0 size=     680kB time=00:00:06.29 bitrate= 885.5kbits/s    
frame=  175 fps= 32 q=27.0 size=     787kB time=00:00:07.08 bitrate= 910.2kbits/s    
frame=  197 fps= 33 q=27.0 size=     984kB time=00:00:07.97 bitrate=1009.9kbits/s    
frame=  218 fps= 33 q=28.0 size=    1101kB time=00:00:08.81 bitrate=1023.9kbits/s    
frame=  237 fps= 34 q=27.0 size=    1236kB time=00:00:09.57 bitrate=1057.3kbits/s    
frame=  245 fps= 32 q=23.0 size=    1287kB time=00:00:09.89 bitrate=1065.2kbits/s    
frame=  258 fps= 31 q=23.0 size=    1407kB time=00:00:10.41 bitrate=1107.2kbits/s    
frame=  292 fps= 33 q=18.0 size=    1571kB time=00:00:11.77 bitrate=1093.0kbits/s    
frame=  315 fps= 34 q=20.0 size=    1696kB time=00:00:12.69 bitrate=1094.3kbits/s    
frame=  338 fps= 35 q=22.0 size=    1895kB time=00:00:13.61 bitrate=1140.4kbits/s    
frame=  365 fps= 35 q=15.0 size=    2006kB time=00:00:14.69 bitrate=1117.8kbits/s    
frame=  381 fps= 35 q=22.0 size=    2136kB time=00:00:15.33 bitrate=1140.8kbits/s    
frame=  401 fps= 35 q=22.0 size=    2243kB time=00:00:16.12 bitrate=1139.1kbits/s    
frame=  425 fps= 36 q=21.0 size=    2420kB time=00:00:17.08 bitrate=1160.0kbits/s    
frame=  446 fps= 36 q=22.0 size=    2531kB time=00:00:17.92 bitrate=1156.8kbits/s    
frame=  466 fps= 36 q=22.0 size=    2709kB time=00:00:18.73 bitrate=1185.0kbits/s    
frame=  475 fps= 35 q=23.0 size=    2755kB time=00:00:19.09 bitrate=1181.9kbits/s    
frame=  487 fps= 35 q=26.0 size=    2894kB time=00:00:19.56 bitrate=1211.7kbits/s    
frame=  505 fps= 35 q=26.0 size=    2980kB time=00:00:20.28 bitrate=1203.3kbits/s    
frame=  520 fps= 35 q=27.0 size=    3072kB time=00:00:20.88 bitrate=1204.9kbits/s    
frame=  536 fps= 34 q=26.0 size=    3172kB time=00:00:21.52 bitrate=1207.3kbits/s    
frame=  552 fps= 34 q=27.0 size=    3302kB time=00:00:22.16 bitrate=1220.4kbits/s    
frame=  571 fps= 34 q=25.0 size=    3403kB time=00:00:22.93 bitrate=1215.7kbits/s    
frame=  585 fps= 34 q=25.0 size=    3526kB time=00:00:23.48 bitrate=1229.9kbits/s    
frame=  604 fps= 34 q=25.0 size=    3648kB time=00:00:24.25 bitrate=1232.1kbits/s    
frame=  630 fps= 35 q=23.0 size=    3782kB time=00:00:25.28 bitrate=1225.6kbits/s    
frame=  652 fps= 35 q=21.0 size=    3967kB time=00:00:26.17 bitrate=1241.5kbits/s    
frame=  662 fps= 34 q=19.0 size=    4009kB time=00:00:26.56 bitrate=1236.6kbits/s    
frame=  680 fps= 34 q=19.0 size=    4102kB time=00:00:27.28 bitrate=1231.7kbits/s    
frame=  696 fps= 34 q=27.0 size=    4225kB time=00:00:27.92 bitrate=1239.5kbits/s    
frame=  713 fps= 34 q=25.0 size=    4307kB time=00:00:28.60 bitrate=1233.4kbits/s    
frame=  724 fps= 34 q=27.0 size=    4387kB time=00:00:29.05 bitrate=1236.8kbits/s    
frame=  737 fps= 34 q=29.0 size=    4469kB time=00:00:29.56 bitrate=1238.1kbits/s    
frame=  749 fps= 33 q=31.0 size=    4562kB time=00:00:30.05 bitrate=1243.3kbits/s    
frame=  760 fps= 33 q=30.0 size=    4626kB time=00:00:30.48 bitrate=1243.1kbits/s    
frame=  773 fps= 33 q=29.0 size=    4756kB time=00:00:31.01 bitrate=1256.1kbits/s    
frame=  783 fps= 33 q=30.0 size=    4825kB time=00:00:31.40 bitrate=1258.8kbits/s    
frame=  791 fps= 32 q=31.0 size=    4885kB time=00:00:31.72 bitrate=1261.6kbits/s    
frame=  801 fps= 32 q=32.0 size=    4953kB time=00:00:32.12 bitrate=1263.0kbits/s    
frame=  813 fps= 32 q=32.0 size=    5019kB time=00:00:32.61 bitrate=1260.5kbits/s    
frame=  829 fps= 32 q=30.0 size=    5127kB time=00:00:33.25 bitrate=1262.8kbits/s    
frame=  845 fps= 32 q=30.0 size=    5271kB time=00:00:33.89 bitrate=1273.7kbits/s    
frame=  863 fps= 32 q=30.0 size=    5380kB time=00:00:34.60 bitrate=1273.6kbits/s    
frame=  881 fps= 32 q=28.0 size=    5474kB time=00:00:35.32 bitrate=1269.2kbits/s    
frame=  895 fps= 32 q=25.0 size=    5542kB time=00:00:35.88 bitrate=1265.1kbits/s    
frame=  915 fps= 32 q=24.0 size=    5688kB time=00:00:36.69 bitrate=1269.9kbits/s    
frame=  929 fps= 32 q=24.0 size=    5793kB time=00:00:37.24 bitrate=1274.0kbits/s    
frame=  945 fps= 32 q=22.0 size=    5933kB time=00:00:37.88 bitrate=1282.9kbits/s    
frame=  971 fps= 32 q=22.0 size=    6059kB time=00:00:38.93 bitrate=1274.8kbits/s    
frame= 1000 fps= 32 q=20.0 size=    6239kB time=00:00:40.08 bitrate=1275.1kbits/s    
frame= 1018 fps= 32 q=20.0 size=    6333kB time=00:00:40.81 bitrate=1271.3kbits/s    
frame= 1042 fps= 33 q=20.0 size=    6476kB time=00:00:41.77 bitrate=1270.0kbits/s    
frame= 1060 fps= 33 q=20.0 size=    6668kB time=00:00:42.49 bitrate=1285.3kbits/s    
frame= 1084 fps= 33 q=17.0 size=    6757kB time=00:00:43.45 bitrate=1273.7kbits/s    
frame= 1105 fps= 33 q=26.0 size=    6917kB time=00:00:44.28 bitrate=1279.4kbits/s    
frame= 1127 fps= 33 q=25.0 size=    7033kB time=00:00:45.16 bitrate=1275.7kbits/s    
frame= 1150 fps= 33 q=23.0 size=    7253kB time=00:00:46.08 bitrate=1289.5kbits/s    
frame= 1162 fps= 33 q=21.0 size=    7315kB time=00:00:46.57 bitrate=1286.7kbits/s    
frame= 1173 fps= 33 q=19.0 size=    7352kB time=00:00:47.01 bitrate=1280.9kbits/s    
frame= 1194 fps= 33 q=19.0 size=    7467kB time=00:00:47.85 bitrate=1278.4kbits/s    
frame= 1207 fps= 33 q=18.0 size=    7596kB time=00:00:48.36 bitrate=1286.7kbits/s    
frame= 1226 fps= 33 q=19.0 size=    7681kB time=00:00:49.13 bitrate=1280.7kbits/s    
frame= 1249 fps= 33 q=20.0 size=    7814kB time=00:00:50.04 bitrate=1279.1kbits/s    
frame= 1272 fps= 33 q=20.0 size=    8038kB time=00:00:50.96 bitrate=1292.0kbits/s    
frame= 1296 fps= 33 q=18.0 size=    8178kB time=00:00:51.92 bitrate=1290.2kbits/s    
frame= 1321 fps= 34 q=14.0 size=    8309kB time=00:00:52.92 bitrate=1286.0kbits/s    
frame= 1346 fps= 34 q=25.0 size=    8463kB time=00:00:53.93 bitrate=1285.5kbits/s    
frame= 1358 fps= 34 q=22.0 size=    8592kB time=00:00:54.40 bitrate=1293.8kbits/s    
frame= 1371 fps= 34 q=24.0 size=    8650kB time=00:00:54.93 bitrate=1290.0kbits/s    
frame= 1379 fps= 33 q=25.0 size=    8686kB time=00:00:55.25 bitrate=1287.8kbits/s    
frame= 1393 fps= 33 q=23.0 size=    8754kB time=00:00:55.80 bitrate=1285.0kbits/s    
frame= 1408 fps= 33 q=24.0 size=    8907kB time=00:00:56.40 bitrate=1293.6kbits/s    
frame= 1428 fps= 33 q=26.0 size=    9065kB time=00:00:57.21 bitrate=1297.8kbits/s    
frame= 1453 fps= 33 q=23.0 size=    9174kB time=00:00:58.21 bitrate=1290.9kbits/s    
frame= 1467 fps= 33 q=23.0 size=    9238kB time=00:00:58.77 bitrate=1287.7kbits/s    
frame= 1486 fps= 33 q=20.0 size=    9342kB time=00:00:59.52 bitrate=1285.8kbits/s    
frame= 1506 fps= 34 q=22.0 size=    9528kB time=00:01:00.33 bitrate=1293.8kbits/s    
frame= 1521 fps= 33 q=23.0 size=    9616kB time=00:01:00.92 bitrate=1292.9kbits/s    
frame= 1536 fps= 33 q=22.0 size=    9688kB time=00:01:01.52 bitrate=1290.0kbits/s    
frame= 1553 fps= 33 q=22.0 size=    9794kB time=00:01:02.20 bitrate=1289.7kbits/s    
frame= 1565 fps= 33 q=22.0 size=    9916kB time=00:01:02.69 bitrate=1295.6kbits/s    
frame= 1582 fps= 33 q=22.0 size=   10022kB time=00:01:03.36 bitrate=1295.8kbits/s    
frame= 1598 fps= 33 q=20.0 size=   10098kB time=00:01:04.00 bitrate=1292.6kbits/s    
frame= 1615 fps= 33 q=22.0 size=   10209kB time=00:01:04.68 bitrate=1293.0kbits/s    
frame= 1636 fps= 33 q=24.0 size=   10374kB time=00:01:05.53 bitrate=1296.8kbits/s    
frame= 1655 fps= 33 q=25.0 size=   10482kB time=00:01:06.28 bitrate=1295.5kbits/s    
frame= 1674 fps= 33 q=27.0 size=   10644kB time=00:01:07.05 bitrate=1300.5kbits/s    
frame= 1694 fps= 33 q=26.0 size=   10765kB time=00:01:07.84 bitrate=1299.9kbits/s    
frame= 1717 fps= 34 q=27.0 size=   10939kB time=00:01:08.77 bitrate=1302.9kbits/s    
frame= 1729 fps= 33 q=25.0 size=   10987kB time=00:01:09.24 bitrate=1299.8kbits/s    
frame= 1741 fps= 33 q=25.0 size=   11042kB time=00:01:09.73 bitrate=1297.0kbits/s    
frame= 1758 fps= 33 q=25.0 size=   11154kB time=00:01:10.40 bitrate=1297.9kbits/s    
frame= 1772 fps= 33 q=25.0 size=   11251kB time=00:01:10.97 bitrate=1298.6kbits/s    
frame= 1790 fps= 33 q=28.0 size=   11420kB time=00:01:11.68 bitrate=1305.1kbits/s    
frame= 1808 fps= 33 q=27.0 size=   11527kB time=00:01:12.40 bitrate=1304.2kbits/s    
frame= 1826 fps= 33 q=29.0 size=   11639kB time=00:01:13.13 bitrate=1303.7kbits/s    
frame= 1841 fps= 33 q=29.0 size=   11743kB time=00:01:13.72 bitrate=1304.8kbits/s    
frame= 1859 fps= 33 q=27.0 size=   11893kB time=00:01:14.45 bitrate=1308.6kbits/s    
frame= 1877 fps= 33 q=23.0 size=   12008kB time=00:01:15.17 bitrate=1308.5kbits/s    
frame= 1896 fps= 33 q=27.0 size=   12126kB time=00:01:15.92 bitrate=1308.3kbits/s    
frame= 1905 fps= 33 q=28.0 size=   12185kB time=00:01:16.28 bitrate=1308.5kbits/s    
frame= 1915 fps= 33 q=22.0 size=   12225kB time=00:01:16.69 bitrate=1305.8kbits/s    
frame= 1931 fps= 33 q=27.0 size=   12372kB time=00:01:17.33 bitrate=1310.6kbits/s    
frame= 1946 fps= 33 q=24.0 size=   12480kB time=00:01:17.93 bitrate=1311.9kbits/s    
frame= 1960 fps= 33 q=26.0 size=   12546kB time=00:01:18.48 bitrate=1309.5kbits/s    
frame= 1979 fps= 33 q=24.0 size=   12642kB time=00:01:19.25 bitrate=1306.8kbits/s    
frame= 1998 fps= 33 q=26.0 size=   12798kB time=00:01:20.00 bitrate=1310.5kbits/s    
frame= 2017 fps= 33 q=23.0 size=   12880kB time=00:01:20.76 bitrate=1306.4kbits/s    
frame= 2027 fps= 33 q=25.0 size=   12985kB time=00:01:21.17 bitrate=1310.5kbits/s    
frame= 2048 fps= 33 q=26.0 size=   13106kB time=00:01:22.00 bitrate=1309.3kbits/s    
frame= 2070 fps= 33 q=24.0 size=   13302kB time=00:01:22.88 bitrate=1314.8kbits/s    
frame= 2084 fps= 33 q=22.0 size=   13367kB time=00:01:23.45 bitrate=1312.1kbits/s    
frame= 2095 fps= 33 q=23.0 size=   13435kB time=00:01:23.88 bitrate=1312.1kbits/s    
frame= 2117 fps= 33 q=24.0 size=   13536kB time=00:01:24.77 bitrate=1308.0kbits/s    
frame= 2137 fps= 33 q=23.0 size=   13753kB time=00:01:25.56 bitrate=1316.7kbits/s    
frame= 2156 fps= 33 q=23.0 size=   13847kB time=00:01:26.33 bitrate=1313.9kbits/s    
frame= 2177 fps= 33 q=24.0 size=   13948kB time=00:01:27.16 bitrate=1310.8kbits/s    
frame= 2196 fps= 33 q=24.0 size=   14071kB time=00:01:27.93 bitrate=1310.8kbits/s    
frame= 2214 fps= 33 q=25.0 size=   14273kB time=00:01:28.64 bitrate=1319.1kbits/s    
frame= 2231 fps= 33 q=25.0 size=   14357kB time=00:01:29.32 bitrate=1316.7kbits/s    
frame= 2246 fps= 33 q=25.0 size=   14431kB time=00:01:29.92 bitrate=1314.7kbits/s    
frame= 2258 fps= 33 q=25.0 size=   14508kB time=00:01:30.41 bitrate=1314.6kbits/s    
frame= 2271 fps= 33 q=25.0 size=   14573kB time=00:01:30.92 bitrate=1313.0kbits/s    
frame= 2280 fps= 33 q=24.0 size=   14723kB time=00:01:31.28 bitrate=1321.2kbits/s    
frame= 2300 fps= 33 q=24.0 size=   14816kB time=00:01:32.09 bitrate=1317.9kbits/s    
frame= 2314 fps= 33 q=25.0 size=   14900kB time=00:01:32.65 bitrate=1317.4kbits/s    
frame= 2331 fps= 33 q=25.0 size=   15005kB time=00:01:33.33 bitrate=1317.0kbits/s    
frame= 2349 fps= 33 q=24.0 size=   15110kB time=00:01:34.05 bitrate=1316.0kbits/s    
frame= 2369 fps= 33 q=27.0 size=   15309kB time=00:01:34.84 bitrate=1322.2kbits/s    
frame= 2388 fps= 33 q=25.0 size=   15400kB time=00:01:35.61 bitrate=1319.4kbits/s    
frame= 2410 fps= 33 q=25.0 size=   15503kB time=00:01:36.49 bitrate=1316.2kbits/s    
frame= 2428 fps= 33 q=26.0 size=   15693kB time=00:01:37.21 bitrate=1322.4kbits/s    
frame= 2441 fps= 33 q=25.0 size=   15788kB time=00:01:37.72 bitrate=1323.4kbits/s    
frame= 2461 fps= 33 q=26.0 size=   15928kB time=00:01:38.53 bitrate=1324.2kbits/s    
frame= 2481 fps= 33 q=27.0 size=   16025kB time=00:01:39.32 bitrate=1321.6kbits/s    
frame= 2506 fps= 33 q=23.0 size=   16195kB time=00:01:40.33 bitrate=1322.3kbits/s    
frame= 2531 fps= 33 q=26.0 size=   16380kB time=00:01:41.33 bitrate=1324.2kbits/s    
frame= 2556 fps= 33 q=20.0 size=   16494kB time=00:01:42.33 bitrate=1320.4kbits/s    
frame= 2583 fps= 33 q=21.0 size=   16734kB time=00:01:43.40 bitrate=1325.7kbits/s    
frame= 2606 fps= 33 q=25.0 size=   16836kB time=00:01:44.32 bitrate=1322.1kbits/s    
frame= 2629 fps= 34 q=24.0 size=   16956kB time=00:01:45.25 bitrate=1319.6kbits/s    
frame= 2651 fps= 34 q=26.0 size=   17154kB time=00:01:46.13 bitrate=1324.0kbits/s    
frame= 2661 fps= 34 q=27.0 size=   17216kB time=00:01:46.53 bitrate=1323.8kbits/s    
frame= 2672 fps= 33 q=28.0 size=   17278kB time=00:01:46.96 bitrate=1323.2kbits/s    
frame= 2691 fps= 33 q=28.0 size=   17403kB time=00:01:47.73 bitrate=1323.3kbits/s    
frame= 2712 fps= 33 q=25.0 size=   17598kB time=00:01:48.56 bitrate=1327.9kbits/s    
frame= 2731 fps= 34 q=24.0 size=   17681kB time=00:01:49.33 bitrate=1324.8kbits/s    
frame= 2754 fps= 34 q=20.0 size=   17774kB time=00:01:50.25 bitrate=1320.7kbits/s    
frame= 2775 fps= 34 q=19.0 size=   17946kB time=00:01:51.08 bitrate=1323.5kbits/s    
frame= 2795 fps= 34 q=20.0 size=   18117kB time=00:01:51.89 bitrate=1326.4kbits/s    
frame= 2821 fps= 34 q=18.0 size=   18234kB time=00:01:52.93 bitrate=1322.6kbits/s    
frame= 2844 fps= 34 q=21.0 size=   18358kB time=00:01:53.85 bitrate=1320.9kbits/s    
frame= 2869 fps= 34 q=24.0 size=   18542kB time=00:01:54.85 bitrate=1322.5kbits/s    
frame= 2883 fps= 34 q=25.0 size=   18674kB time=00:01:55.41 bitrate=1325.5kbits/s    
frame= 2894 fps= 34 q=25.0 size=   18741kB time=00:01:55.84 bitrate=1325.3kbits/s    
frame= 2915 fps= 34 q=23.0 size=   18858kB time=00:01:56.69 bitrate=1323.8kbits/s    
frame= 2937 fps= 34 q=29.0 size=   18976kB time=00:01:57.56 bitrate=1322.2kbits/s    
frame= 2956 fps= 34 q=24.0 size=   19136kB time=00:01:58.33 bitrate=1324.7kbits/s    
frame= 2977 fps= 34 q=24.0 size=   19252kB time=00:01:59.16 bitrate=1323.5kbits/s    
frame= 3000 fps= 34 q=23.0 size=   19472kB time=00:02:00.08 bitrate=1328.4kbits/s    
frame= 3020 fps= 34 q=22.0 size=   19582kB time=00:02:00.89 bitrate=1326.9kbits/s    
frame= 3040 fps= 34 q=20.0 size=   19668kB time=00:02:01.68 bitrate=1324.0kbits/s    
frame= 3056 fps= 34 q=27.0 size=   19792kB time=00:02:02.32 bitrate=1325.4kbits/s    
frame= 3073 fps= 34 q=26.0 size=   19946kB time=00:02:03.00 bitrate=1328.4kbits/s    
frame= 3085 fps= 34 q=23.0 size=   20002kB time=00:02:03.49 bitrate=1326.8kbits/s    
frame= 3094 fps= 34 q=21.0 size=   20073kB time=00:02:03.84 bitrate=1327.8kbits/s    
frame= 3114 fps= 34 q=21.0 size=   20200kB time=00:02:04.65 bitrate=1327.5kbits/s    
frame= 3137 fps= 34 q=19.0 size=   20296kB time=00:02:05.56 bitrate=1324.1kbits/s    
frame= 3158 fps= 34 q=17.0 size=   20452kB time=00:02:06.40 bitrate=1325.5kbits/s    
frame= 3183 fps= 34 q=16.0 size=   20578kB time=00:02:07.40 bitrate=1323.2kbits/s    
frame= 3203 fps= 34 q=19.0 size=   20699kB time=00:02:08.21 bitrate=1322.6kbits/s    
frame= 3222 fps= 34 q=23.0 size=   20844kB time=00:02:08.96 bitrate=1324.1kbits/s    
frame= 3243 fps= 34 q=25.0 size=   20960kB time=00:02:09.81 bitrate=1322.7kbits/s    
frame= 3259 fps= 34 q=28.0 size=   21094kB time=00:02:10.45 bitrate=1324.6kbits/s    
frame= 3279 fps= 34 q=27.0 size=   21228kB time=00:02:11.24 bitrate=1325.0kbits/s    
frame= 3293 fps= 34 q=27.0 size=   21367kB time=00:02:11.81 bitrate=1327.9kbits/s    
frame= 3302 fps= 34 q=26.0 size=   21440kB time=00:02:12.16 bitrate=1329.0kbits/s    
frame= 3324 fps= 34 q=26.0 size=   21539kB time=00:02:13.05 bitrate=1326.1kbits/s    
frame= 3344 fps= 34 q=24.0 size=   21625kB time=00:02:13.84 bitrate=1323.5kbits/s    
frame= 3365 fps= 34 q=27.0 size=   21774kB time=00:02:14.69 bitrate=1324.3kbits/s    
frame= 3382 fps= 34 q=28.0 size=   21915kB time=00:02:15.36 bitrate=1326.3kbits/s    
frame= 3400 fps= 34 q=28.0 size=   22022kB time=00:02:16.08 bitrate=1325.6kbits/s    
frame= 3418 fps= 34 q=28.0 size=   22138kB time=00:02:16.81 bitrate=1325.6kbits/s    
frame= 3433 fps= 34 q=29.0 size=   22281kB time=00:02:17.40 bitrate=1328.3kbits/s    
frame= 3454 fps= 34 q=28.0 size=   22401kB time=00:02:18.24 bitrate=1327.4kbits/s    
frame= 3471 fps= 34 q=26.0 size=   22509kB time=00:02:18.92 bitrate=1327.3kbits/s    
frame= 3486 fps= 34 q=27.0 size=   22615kB time=00:02:19.52 bitrate=1327.8kbits/s    
frame= 3500 fps= 34 q=26.0 size=   22653kB time=00:02:20.09 bitrate=1324.6kbits/s    
frame= 3517 fps= 34 q=27.0 size=   22769kB time=00:02:20.77 bitrate=1325.0kbits/s    
frame= 3529 fps= 34 q=28.0 size=   22874kB time=00:02:21.24 bitrate=1326.6kbits/s    
frame= 3545 fps= 34 q=28.0 size=   22988kB time=00:02:21.88 bitrate=1327.2kbits/s    
frame= 3561 fps= 34 q=27.0 size=   23114kB time=00:02:22.52 bitrate=1328.5kbits/s    
frame= 3584 fps= 34 q=24.0 size=   23269kB time=00:02:23.44 bitrate=1328.9kbits/s    
frame= 3606 fps= 34 q=20.0 size=   23424kB time=00:02:24.32 bitrate=1329.6kbits/s    
frame= 3632 fps= 34 q=19.0 size=   23523kB time=00:02:25.36 bitrate=1325.6kbits/s    
frame= 3654 fps= 34 q=25.0 size=   23648kB time=00:02:26.24 bitrate=1324.7kbits/s    
frame= 3667 fps= 34 q=28.0 size=   23757kB time=00:02:26.77 bitrate=1326.0kbits/s    
frame= 3673 fps= 34 q=28.0 size=   23812kB time=00:02:27.00 bitrate=1326.9kbits/s    
frame= 3679 fps= 34 q=27.0 size=   23867kB time=00:02:27.24 bitrate=1327.9kbits/s    
frame= 3691 fps= 34 q=27.0 size=   23940kB time=00:02:27.73 bitrate=1327.5kbits/s    
frame= 3708 fps= 34 q=27.0 size=   24028kB time=00:02:28.41 bitrate=1326.2kbits/s    
frame= 3723 fps= 34 q=27.0 size=   24139kB time=00:02:29.01 bitrate=1327.1kbits/s    
frame= 3739 fps= 34 q=26.0 size=   24215kB time=00:02:29.65 bitrate=1325.5kbits/s    
frame= 3752 fps= 34 q=28.0 size=   24341kB time=00:02:30.16 bitrate=1327.9kbits/s    
frame= 3763 fps= 34 q=27.0 size=   24442kB time=00:02:30.61 bitrate=1329.4kbits/s    
frame= 3778 fps= 34 q=23.0 size=   24555kB time=00:02:31.21 bitrate=1330.3kbits/s    
frame= 3797 fps= 34 q=24.0 size=   24669kB time=00:02:31.97 bitrate=1329.7kbits/s    
frame= 3812 fps= 34 q=22.0 size=   24713kB time=00:02:32.57 bitrate=1326.9kbits/s    
frame= 3820 fps= 34 q=23.0 size=   24773kB time=00:02:32.89 bitrate=1327.3kbits/s    
frame= 3834 fps= 34 q=18.0 size=   24857kB time=00:02:33.45 bitrate=1327.0kbits/s    
frame= 3850 fps= 34 q=26.0 size=   24922kB time=00:02:34.09 bitrate=1325.0kbits/s    
frame= 3863 fps= 34 q=25.0 size=   25033kB time=00:02:34.60 bitrate=1326.4kbits/s    
frame= 3885 fps= 34 q=22.0 size=   25195kB time=00:02:35.49 bitrate=1327.3kbits/s    
frame= 3903 fps= 34 q=24.0 size=   25343kB time=00:02:36.20 bitrate=1329.1kbits/s    
frame= 3922 fps= 34 q=23.0 size=   25420kB time=00:02:36.97 bitrate=1326.6kbits/s    
frame= 3941 fps= 34 q=23.0 size=   25602kB time=00:02:37.73 bitrate=1329.6kbits/s    
frame= 3960 fps= 34 q=18.0 size=   25738kB time=00:02:38.48 bitrate=1330.4kbits/s    
frame= 3976 fps= 34 q=18.0 size=   25791kB time=00:02:39.12 bitrate=1327.8kbits/s    
frame= 3986 fps= 34 q=17.0 size=   25848kB time=00:02:39.53 bitrate=1327.3kbits/s    
frame= 4003 fps= 34 q=26.0 size=   25965kB time=00:02:40.21 bitrate=1327.7kbits/s    
frame= 4024 fps= 34 q=24.0 size=   26135kB time=00:02:41.04 bitrate=1329.4kbits/s    
frame= 4039 fps= 34 q=24.0 size=   26219kB time=00:02:41.64 bitrate=1328.7kbits/s    
frame= 4059 fps= 34 q=23.0 size=   26320kB time=00:02:42.45 bitrate=1327.2kbits/s    
frame= 4077 fps= 34 q=22.0 size=   26449kB time=00:02:43.17 bitrate=1327.8kbits/s    
frame= 4094 fps= 34 q=29.0 size=   26602kB time=00:02:43.84 bitrate=1330.1kbits/s    
frame= 4112 fps= 34 q=29.0 size=   26709kB time=00:02:44.56 bitrate=1329.6kbits/s    
frame= 4127 fps= 34 q=30.0 size=   26807kB time=00:02:45.16 bitrate=1329.6kbits/s    
frame= 4144 fps= 34 q=31.0 size=   26916kB time=00:02:45.84 bitrate=1329.5kbits/s    
frame= 4154 fps= 33 q=31.0 size=   27001kB time=00:02:46.25 bitrate=1330.5kbits/s    
frame= 4170 fps= 33 q=31.0 size=   27107kB time=00:02:46.89 bitrate=1330.6kbits/s    
frame= 4184 fps= 33 q=30.0 size=   27222kB time=00:02:47.44 bitrate=1331.8kbits/s    
frame= 4200 fps= 33 q=27.0 size=   27347kB time=00:02:48.08 bitrate=1332.8kbits/s    
frame= 4216 fps= 33 q=27.0 size=   27422kB time=00:02:48.72 bitrate=1331.4kbits/s    
frame= 4241 fps= 33 q=24.0 size=   27581kB time=00:02:49.72 bitrate=1331.2kbits/s    
frame= 4263 fps= 33 q=23.0 size=   27685kB time=00:02:50.60 bitrate=1329.4kbits/s    
frame= 4271 fps= 33 q=-1.0 Lsize=   28175kB time=00:02:50.85 bitrate=1350.9kbits/s    
video:20042kB audio:8008kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.448304%
[libx264 @ 0xff8900] frame I:60    Avg QP:15.06  size: 67955
[libx264 @ 0xff8900] frame P:1597  Avg QP:18.05  size:  8058
[libx264 @ 0xff8900] frame B:2614  Avg QP:23.17  size:  1368
[libx264 @ 0xff8900] consecutive B-frames: 14.9%  6.9% 10.9% 67.3%
[libx264 @ 0xff8900] mb I  I16..4: 15.1%  0.0% 84.9%
[libx264 @ 0xff8900] mb P  I16..4:  2.0%  0.0%  5.8%  P16..4: 23.9% 11.0%  7.3%  0.0%  0.0%    skip:50.0%
[libx264 @ 0xff8900] mb B  I16..4:  0.1%  0.0%  0.6%  B16..8: 18.9%  3.0%  0.7%  direct: 0.9%  skip:75.8%  L0:33.5% L1:59.4% BI: 7.1%
[libx264 @ 0xff8900] coded y,uvDC,uvAC intra: 75.1% 89.0% 68.7% inter: 7.4% 10.7% 2.3%
[libx264 @ 0xff8900] i16 v,h,dc,p: 19% 32%  8% 41%
[libx264 @ 0xff8900] i4 v,h,dc,ddl,ddr,vr,hd,vl,hu: 24% 21% 12%  6%  8%  8%  7%  8%  6%
[libx264 @ 0xff8900] i8c dc,h,v,p: 41% 28% 18% 14%
[libx264 @ 0xff8900] Weighted P-Frames: Y:0.2% UV:0.1%
[libx264 @ 0xff8900] ref P L0: 73.7% 12.0% 10.6%  3.6%  0.0%
[libx264 @ 0xff8900] ref B L0: 91.6%  6.8%  1.7%
[libx264 @ 0xff8900] ref B L1: 94.8%  5.2%
[libx264 @ 0xff8900] kb/s:961.00