#!/bin/bash

USER_NAME=arnaudhb
USER_ID=`id -u`
IMG_NAME=$(basename $(pwd))

xhost + si:localuser:root

docker run -it --rm \
 -e DISPLAY=$DISPLAY \
 -e PULSE_SERVER=/run/pulse/native \
 -e PULSE_COOKIE=/run/pulse/cookie \
 -v /tmp/.X11-unix:/tmp/.X11-unix \
 -v /var/run/user/$USER_ID/pulse:/run/pulse \
 -v /var/run/dbus:/var/run/dbus \
 -v ~/.config/pulse/cookie:/run/pulse/cookie \
 -v /etc/machine-id:/etc/machine-id \
 -v /var/lib/dbus:/var/lib/dbus \
 -v /dev/shm:/dev/shm \
 -v /dev/dri:/dev/dri \
 --security-opt seccomp:$PWD/chrome.json \
 --group-add audio \
 --group-add video \
 $DOCKER_VOLUMES \
 $USER_NAME/$IMG_NAME $*

xhost - si:localuser:root

# Sharing audio between host and container
# did some mess on the host.
# Kill pulseaudio process and let 
# start-stop-daemon restart it with unprivileged
# user to get back audio
killall pulseaudio
