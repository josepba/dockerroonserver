#!/bin/sh
if ! [ -d /opt/RoonStuff/RoonServer ]
then
  cd /opt/RoonStuff
  tar xf /rooninstall/${ROON_SERVER_PKG}
fi
exec /opt/RoonStuff/RoonServer/start.sh

