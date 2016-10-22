#!/bin/bash

# Useful when running in detached mode
# in order to have at least one
# running process
if [ -z "$*" ] ;
then
  /bin/sleep infinity
else
  exec $*
fi
