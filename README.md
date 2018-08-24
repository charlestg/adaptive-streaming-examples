# shaka-packager-examples
Build Adaptive Streaming Server with Docker:
    Download HTTP videos, Multicast streams
    Transcoding
    Packaging/DRM
    Web Client
    Run in HTTP server
    Play

Example follows the instruction by Google's Shaka Packager Tutorial: https://google.github.io/shaka-packager/html/tutorials/tutorials.html

## Required Docker Containers
```
docker pull google/shaka-packager
docker pull charlestg/ffmpeg_centos7
docker pull charlestg/httpds
```


## Download Sample Video

This sample video will be used throughout the examples

```
cd /var/tmp/
curl -o test.mp4 https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_30mb.mp4
```

## Clone the project Example

```
git clone https://github.com/charlestg/shaka-packager-examples.git
cd shaka-packager-examples

```

## Dash Ondemand Example

```
# UseTranscode videos, output videos in /var/tmp/test.mp4.t folder
transcode/h264_360p.sh    /var/tmp/test.mp4
transcode/h264_480p.sh    /var/tmp/test.mp4
transcode/h264_720p.sh    /var/tmp/test.mp4
transcode/h264_1080p.sh   /var/tmp/test.mp4

# packaged video in /var/tmp/test.mp4.t/ondemand folder
dash/ondemand.sh   /var/tmp/test.mp4

# Create shaka.html and dashjs.html in /var/tmp/test.mp4.t/ondemand folder
web/ondemind.sh   /var/tmp/test.mp4

# Launch https web server
cd /var/tmp/test.mp4.t
docker run -dit -v `pwd`:/usr/local/apache2/htdocs/ --name httpds -p 9080:80 -p 8443:443 charlestg/httpds

# Point browser to https://<ip>:8443/
# Click "dash h.264 ondemand: dashjs shakajs" to play video

# Stop HTTP web server
docker stop charlestg/httpds
docker rm charlestg/httpds    
```

## Dash Widevine DRM protected Example

```
# UseTranscode videos, output videos in /var/tmp/test.mp4.t folder
transcode/h264_360p.sh    /var/tmp/test.mp4
transcode/h264_480p.sh    /var/tmp/test.mp4
transcode/h264_720p.sh    /var/tmp/test.mp4
transcode/h264_1080p.sh   /var/tmp/test.mp4

# packaged video in /var/tmp/test.mp4.t/dash_widevine folder
dash/widevine.sh   /var/tmp/test.mp4

# Create shaka.html and dashjs.html in /var/tmp/test.mp4.t/widevine_dash folder
web/widevine_dash.sh    /var/tmp/test.mp4
web/index.sh            /var/tmp/test.mp4

# Launch https web server
cd /var/tmp/test.mp4.t
docker run -dit -v `pwd`:/usr/local/apache2/htdocs/ --name httpds -p 9080:80 -p 8443:443 charlestg/httpds

# Point browser to https://<ip>:8443/
# Click "dash h.264 widevine: dashjs shakajs" to play video

# Stop HTTP web server
docker stop charlestg/httpds
docker rm charlestg/httpds 
```
