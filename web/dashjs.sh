#!/bin/bash
# https://google.github.io/shaka-packager/html/tutorials/dash.html#synopsis
# Package 4 streams

VIDEOPATH=$1

DIR=$(dirname $VIDEOPATH)
FILENAME=$(basename $VIDEOPATH)
FILEBASE=${FILENAME%.*}
cd $DIR

cat <<EOF > ${FILENAME}.t/ondemand/index.html
<!DOCTYPE html>
<html>
<!-- Media streaming example
  Reads an .mpd file created using mp4box and plays the file
-->
<head>
  <meta charset="utf-8" />
  <title>Media streaming example</title>
  <style>
    body,div,video{
      padding: 0;
      margin: 0;
    }
    video{
            width:640px;
            height:360px;
    }
  </style>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/dashjs/2.9.0/dash.all.min.js"></script>

  <script>
      function init() {
          var video,
              player,
              url = "h264.mpd";

          video = document.querySelector("video");
          player = dashjs.MediaPlayer().create();
          player.initialize(video, url, true);
      }
  </script>
</head>

<body onload="init();">
  <video data-dashjs-player autoplay></video>
</body>
</html>

EOF

exit
