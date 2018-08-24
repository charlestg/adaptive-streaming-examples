#!/bin/bash
# https://google.github.io/shaka-packager/html/tutorials/dash.html#synopsis
# Package 4 streams

VIDEOPATH=$1

DIR=$(dirname $VIDEOPATH)
FILENAME=$(basename $VIDEOPATH)
FILEBASE=${FILENAME%.*}
cd $DIR

cat <<EOF > ${FILENAME}.t/index.html
<!DOCTYPE html>
<html>

<p>dash h.264 ondemand<p>
<a href="ondemand/dashjs.html">dashjs</a>  <a href="ondemand/shaka.html">shakajs</a>


<p>dash h.264 widevine<p>
<a href="dash_widevine/dashjs.html">dashjs</a>  <a href="dash_widevine/shaka.html">shakajs</a>
</html>

EOF