#!/bin/bash
export DATA_VOL=""       # Configure the directory where Roon stores data on the host
export MUSIC_VOL=""      # Configure the directory where 
export SOFTWARE_VOL=""   # Configure the Host directory to be mounted to hold the Roon Software
docker run --name RoonServer --net=host --ulimit nofile=8192:8192 -d --restart=always -v ${DATA_VOL}:/var/roon -v ${MUSIC_VOL}:/music -v ${SOFTWARE_VOL}:/opt/RoonStuff josepba/roonserver