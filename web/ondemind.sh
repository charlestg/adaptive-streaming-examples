#!/bin/bash

#!/bin/bash
# https://google.github.io/shaka-packager/html/tutorials/dash.html#synopsis
# Package 4 streams

VIDEOPATH=$1

DIR=$(dirname $VIDEOPATH)
FILENAME=$(basename $VIDEOPATH)
FILEBASE=${FILENAME%.*}
cd $DIR

cat <<EOF > ${FILENAME}.t/ondemand/shaka.html
<!DOCTYPE html>
<html>
  <head>
    <!-- Shaka Player compiled library: -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/shaka-player/2.4.3/shaka-player.compiled.js"></script>
    <!-- Your application source: -->
    <script>
        var manifestUri = 'h264.mpd';
        
        function initApp() {
          // Install built-in polyfills to patch browser incompatibilities.
          shaka.polyfill.installAll();
        
          // Check to see if the browser supports the basic APIs Shaka needs.
          if (shaka.Player.isBrowserSupported()) {
            // Everything looks good!
            initPlayer();
          } else {
            // This browser does not have the minimum set of APIs we need.
            console.error('Browser not supported!');
          }
        }
        
        function initPlayer() {
          // Create a Player instance.
          var video = document.getElementById('video');
          var player = new shaka.Player(video);
        
          // Attach player to the window to make it easy to access in the JS console.
          window.player = player;
        
          // Listen for error events.
          player.addEventListener('error', onErrorEvent);
        
          // Try to load a manifest.
          // This is an asynchronous process.
          player.load(manifestUri).then(function() {
            // This runs if the asynchronous load is successful.
            console.log('The video has now been loaded!');
          }).catch(onError);  // onError is executed if the asynchronous load fails.
        }
        
        function onErrorEvent(event) {
          // Extract the shaka.util.Error object from the event.
          onError(event.detail);
        }
        
        function onError(error) {
          // Log the error.
          console.error('Error code', error.code, 'object', error);
        }
        
        document.addEventListener('DOMContentLoaded', initApp);
    
    </script>
  </head>
  <body>
    <video id="video"
           width="640"
           poster="//shaka-player-demo.appspot.com/assets/poster.jpg"
           controls autoplay></video>
  </body>
</html>

EOF


cat <<EOF > ${FILENAME}.t/ondemand/dashjs.html
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