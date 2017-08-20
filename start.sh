#!/bin/bash

# Generate secrets if this is the first run
if [ ! -f /.fist-run ]; then

export JICOFO_SECRET=`pwgen -s 16 1`
export JVB_SECRET=`pwgen -s 16 1`
export FOCUS_SECRET=`pwgen -s 16 1`

# Substitute configuration
for VARIABLE in `env | cut -f1 -d=`; do
  sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" /etc/jitsi/*/* /etc/nginx/nginx.conf /etc/prosody/prosody.cfg.lua
done

fi

# TODO: improve process management
/etc/init.d/prosody restart && \
/etc/init.d/jitsi-videobridge restart && \
/etc/init.d/jicofo restart && \
/etc/init.d/nginx restart
