## ubuntu-dev:build-automation


### Description
Docker image for development.

Inherit from [arnaudh/ubuntu-dev-base](https://github.com/arnaudhb/ubuntu-dev-base) image

Install all the needed packages to have a working development environment inside a docker container: 
  * Google Chrome browse
  * Mozilla Firefox
  * Java 8u102
  * Apache Maven 3.3.9
  * Gradle 3.1
  * That's it, but other applications will follow :)

The image will be tagged on the [Docker Store](https://store.docker.com/community/images/arnaudhb/ubuntu-dev) for each new application, so it will be easy to inherit from this tag and build your own image.

Having the sound to work can be painful, as you have different configurations on your host.
The aim it to use resources of the host (with volumes) to stream audio on the soundcard.
This image uses the pulseaudio server of the host to play sounds.

It has been sucessfully tested with Ubuntu 16.04 host.


### Usage

#### Image start
Run this image with the command : 
```sh
USER_NAME=arnaudhb
USER_ID=`id -u`
IMG_NAME=$(basename $(pwd))
IMG_TAG=browser

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
 $USER_NAME/$IMG_NAME:$TAG

```

#### Google Chrome

Inside the container, start Chrome with the command

 ```sh   
    $> chrome
 ```

Feel free the use volumes to map user data dir (default in /root/.config/google-chrome) to be able to persist data over container starting.


#### Mozilla Firefox 

Inside the container, start Firefox with the command

 ```sh   
    $> firefox
 ```

Feel free the use volumes to map user profiles dir (default in /root/.firefox) to be able to persist data over container starting.


#### Java

Inside the container, check Java installation with the command 

 ```sh   
    $> java -version
    java version "1.8.0_102"
    Java(TM) SE Runtime Environment (build 1.8.0_102-b14)
    Java HotSpot(TM) 64-Bit Server VM (build 25.102-b14, mixed mode)
 ```


#### Automation build tool : Maven

Inside the container, check Maven installation with the command

 ```sh   
    $> mvn -version
    Apache Maven 3.3.9 (bb52d8502b132ec0a5a3f4c09453c07478323dc5; 2015-11-10T16:41:47+00:00)
    Maven home: /opt/maven
    Java version: 1.8.0_102, vendor: Oracle Corporation
    Java home: /opt/jdk1.8.0_102/jre
    Default locale: en_US, platform encoding: ANSI_X3.4-1968
    OS name: "linux", version: "4.4.0-45-generic", arch: "amd64", family: "unix"   
 ```


#### Automation build tool : Gradle

Inside the container, check Gradle installation with the command

 ```sh   
    $> gradle -version
------------------------------------------------------------
Gradle 3.1
------------------------------------------------------------

Build time:   2016-09-19 10:53:53 UTC
Revision:     13f38ba699afd86d7cdc4ed8fd7dd3960c0b1f97

Groovy:       2.4.7
Ant:          Apache Ant(TM) version 1.9.6 compiled on June 29 2015
JVM:          1.8.0_102 (Oracle Corporation 25.102-b14)
OS:           Linux 4.4.0-45-generic amd64
 ```


### Troubleshooting

If you start containers with a specific user, ensure root user is allowed to connect to the X11 server of the host :
 ```sh   
    xhost + si:localuser:root
 ```
 
And test with:
 ```sh   
    xeyes
 ```

A sample WAV file is available for testing sound: 
 ```sh   
    paplay /root/send.wav
 ```

It seems using sounds in the container (few developers can work without music :) ) breaks the pulseaudio server and disable the sound on the host. I didn't figure out why, but it can easily workarounded by killing pulseaudio server and let start-stop-daemon restart it automatically. Check the run.sh script to see a working example.

Anyway, you could listen music direcly from the host but having all enclosed within a container, without dependencies with the host (other than its resources), is a challenge :D


## References:
https://stackoverflow.com/questions/16296753/can-you-run-gui-apps-in-a-docker-container

http://stackoverflow.com/questions/28985714/run-apps-using-audio-in-a-docker-container

https://github.com/sameersbn/docker-browser-box

https://github.com/jessfraz/dockerfiles/tree/master/chrome/stable

https://github.com/jessfraz/dockerfiles/issues/156

