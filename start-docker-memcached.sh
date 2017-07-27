#!/bin/bash
sh $SHELLSCRIPTS/container-running.sh memcached;
running=$?

if [ $running -eq 0 ]
then
    echo "Memcached Docker is already running";
    runsuccess=0;
else
    sh $SHELLSCRIPTS/container-exists.sh memcached;
    exists=$?;

    if [ $exists -eq 0 ]
    then
        docker rm -f memcached;
    fi

    docker run -d \
    --name memcached \
    -p 11211:11211 \
    --restart "unless-stopped" \
    memcached:alpine;
fi
