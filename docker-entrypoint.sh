#!/bin/bash


# Set environment variables

export TERM=xterm
export JAVA_HOME='/opt/jdk'

# Update PATH
export PATH="$PATH:$JAVA_HOME/bin"


# Useful when running in detached mode
# in order to have at least one
# running process
if [ -z "$*" ] ;
then
  /bin/sleep infinity
else
  exec $*
fi
