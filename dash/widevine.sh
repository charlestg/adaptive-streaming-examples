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
    mkdir -p dash_widevine
    
    packager \
          in=h264_baseline_360p_600.mp4,stream=audio,output=dash_widevine/audio.mp4 \
          in=h264_baseline_360p_600.mp4,stream=video,output=dash_widevine/h264_360p.mp4 \
          in=h264_main_480p_1000.mp4,stream=video,output=dash_widevine/h264_480p.mp4 \
          in=h264_main_720p_3000.mp4,stream=video,output=dash_widevine/h264_720p.mp4 \
          in=h264_high_1080p_6000.mp4,stream=video,output=dash_widevine/h264_1080p.mp4 \
          --enable_widevine_encryption \
          --key_server_url https://license.uat.widevine.com/cenc/getcontentkey/widevine_test \
          --content_id 7465737420636f6e74656e74206964 \
          --signer widevine_test \
          --aes_signing_key 1ae8ccd0e7985cc0b6203a55855a1034afc252980e970ca90e5202689f947ab9 \
          --aes_signing_iv d58ce954203b7c9a9a9d467f59839249 \
          --mpd_output dash_widevine/h264.mpd \
          --hls_master_playlist_output dash_widevine/h264_master.m3u8
    
EOF



exit

[0824/082231:INFO:demuxer.cc(88)] Demuxer::Run() on file 'h264_baseline_360p_600.mp4'.
[0824/082231:INFO:demuxer.cc(160)] Initialize Demuxer for file 'h264_baseline_360p_600.mp4'.
[0824/082231:INFO:demuxer.cc(88)] Demuxer::Run() on file 'h264_high_1080p_6000.mp4'.
[0824/082231:INFO:demuxer.cc(160)] Initialize Demuxer for file 'h264_high_1080p_6000.mp4'.
[0824/082231:INFO:demuxer.cc(88)] Demuxer::Run() on file 'h264_main_480p_1000.mp4'.
[0824/082231:INFO:demuxer.cc(160)] Initialize Demuxer for file 'h264_main_480p_1000.mp4'.
[0824/082231:INFO:demuxer.cc(88)] Demuxer::Run() on file 'h264_main_720p_3000.mp4'.
[0824/082231:INFO:demuxer.cc(160)] Initialize Demuxer for file 'h264_main_720p_3000.mp4'.
[0824/082235:INFO:single_segment_segmenter.cc(107)] Update media header (moov) and rewrite the file to 'dash_widevine/h264_360p.mp4'.
[0824/082236:INFO:single_segment_segmenter.cc(107)] Update media header (moov) and rewrite the file to 'dash_widevine/h264_480p.mp4'.
[0824/082237:INFO:mp4_muxer.cc(166)] MP4 file 'dash_widevine/h264_360p.mp4' finalized.
[0824/082238:INFO:single_segment_segmenter.cc(107)] Update media header (moov) and rewrite the file to 'dash_widevine/h264_720p.mp4'.
[0824/082238:INFO:single_segment_segmenter.cc(107)] Update media header (moov) and rewrite the file to 'dash_widevine/audio.mp4'.
[0824/082239:INFO:mp4_muxer.cc(166)] MP4 file 'dash_widevine/h264_480p.mp4' finalized.
[0824/082243:INFO:mp4_muxer.cc(166)] MP4 file 'dash_widevine/audio.mp4' finalized.
[0824/082243:INFO:mp4_muxer.cc(166)] MP4 file 'dash_widevine/h264_720p.mp4' finalized.
[0824/082243:INFO:single_segment_segmenter.cc(107)] Update media header (moov) and rewrite the file to 'dash_widevine/h264_1080p.mp4'.
[0824/082253:INFO:mp4_muxer.cc(166)] MP4 file 'dash_widevine/h264_1080p.mp4' finalized.
Packaging completed successfully.