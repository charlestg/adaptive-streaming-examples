#!/bin/bash
# https://google.github.io/shaka-packager/html/tutorials/dash.html#synopsis
# Package 4 streams

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
    google/shaka-packager bash -s <<EOF
    
    cd ${FILENAME}.t
    mkdir -p ondemand
    
    packager \
      in=h264_baseline_360p_600.mp4,stream=audio,output=ondemand/audio.mp4 \
      in=h264_baseline_360p_600.mp4,stream=video,output=ondemand/h264_360p.mp4 \
      in=h264_main_480p_1000.mp4,stream=video,output=ondemand/h264_480p.mp4 \
      in=h264_main_720p_3000.mp4,stream=video,output=ondemand/h264_720p.mp4 \
      in=h264_high_1080p_6000.mp4,stream=video,output=ondemand/h264_1080p.mp4 \
      --mpd_output ondemand/h264.mpd
    
EOF




exit
      in=input_text.vtt,stream=text,output=output_text.vtt \
    packager \
      in=${FILEBASE}_360p_600.mp4,stream=audio,output=packaged/audio.mp4 \
      in=input_text.vtt,stream=text,output=output_text.vtt \
      in=${FILEBASE}_360p_600.mp4,stream=video,output=packaged/h264_360p.mp4 \
      in=${FILEBASE}_480p_1000.mp4,stream=video,output=packaged/h264_480p.mp4 \
      in=${FILEBASE}_720p_3000.mp4,stream=video,output=packaged/h264_720p.mp4 \
      in=${FILEBASE}_1080p_6000.mp4,stream=video,output=packaged/h264_1080p.mp4 \
      --mpd_output packaged/h264.mpd
      
mkdir: cannot create directory 'packaged': File exists
[0822/073046:INFO:demuxer.cc(88)] Demuxer::Run() on file 'big_buck_bunny_720p_30mb_1080p_6000.mp4'.
[0822/073046:INFO:demuxer.cc(160)] Initialize Demuxer for file 'big_buck_bunny_720p_30mb_1080p_6000.mp4'.
[0822/073046:INFO:demuxer.cc(88)] Demuxer::Run() on file 'big_buck_bunny_720p_30mb_360p_600.mp4'.
[0822/073046:INFO:demuxer.cc(160)] Initialize Demuxer for file 'big_buck_bunny_720p_30mb_360p_600.mp4'.
[0822/073046:INFO:demuxer.cc(88)] Demuxer::Run() on file 'big_buck_bunny_720p_30mb_480p_1000.mp4'.
[0822/073046:INFO:demuxer.cc(160)] Initialize Demuxer for file 'big_buck_bunny_720p_30mb_480p_1000.mp4'.
[0822/073046:INFO:demuxer.cc(88)] Demuxer::Run() on file 'big_buck_bunny_720p_30mb_720p_3000.mp4'.
[0822/073046:INFO:demuxer.cc(160)] Initialize Demuxer for file 'big_buck_bunny_720p_30mb_720p_3000.mp4'.
[0822/073046:INFO:single_segment_segmenter.cc(107)] Update media header (moov) and rewrite the file to 'packaged/h264_480p.mp4'.
[0822/073046:INFO:single_segment_segmenter.cc(107)] Update media header (moov) and rewrite the file to 'packaged/h264_360p.mp4'.
[0822/073046:INFO:mp4_muxer.cc(166)] MP4 file 'packaged/h264_480p.mp4' finalized.
[0822/073046:INFO:mp4_muxer.cc(166)] MP4 file 'packaged/h264_360p.mp4' finalized.
[0822/073046:INFO:single_segment_segmenter.cc(107)] Update media header (moov) and rewrite the file to 'packaged/audio.mp4'.
[0822/073046:INFO:mp4_muxer.cc(166)] MP4 file 'packaged/audio.mp4' finalized.
[0822/073046:INFO:single_segment_segmenter.cc(107)] Update media header (moov) and rewrite the file to 'packaged/h264_720p.mp4'.
[0822/073047:INFO:mp4_muxer.cc(166)] MP4 file 'packaged/h264_720p.mp4' finalized.
[0822/073047:INFO:single_segment_segmenter.cc(107)] Update media header (moov) and rewrite the file to 'packaged/h264_1080p.mp4'.
[0822/073047:INFO:mp4_muxer.cc(166)] MP4 file 'packaged/h264_1080p.mp4' finalized.
Packaging completed successfully.      