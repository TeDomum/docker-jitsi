#!/bin/bash

# Generate secrets if this is the first run
if [ ! -f /.fist-run ]; then

touch /.first-run
export JICOFO_SECRET=`pwgen -s 16 1`
export JVB_SECRET=`pwgen -s 16 1`
export FOCUS_SECRET=`pwgen -s 16 1`
export LOCAL_IP=`grep $(hostname) /etc/hosts | cut -f1`

# Substitute configuration
for VARIABLE in `env | cut -f1 -d=`; do
  sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" /etc/jitsi/*/* /etc/nginx/nginx.conf /etc/prosody/prosody.cfg.lua
done

/etc/init.d/prosody restart
prosodyctl register focus "auth.$DOMAIN" $FOCUS_SECRET

fi

# TODO: improve process management
/etc/init.d/prosody restart
/etc/init.d/jicofo restart
/etc/init.d/jitsi-videobridge restart
exec nginx -g 'daemon off;'
