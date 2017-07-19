#!/bin/bash
sh $SHELLSCRIPTS/container-running.sh activemq
running=$?

if [ $running -eq 0 ]
then
    echo "Activemq Docker is already running";
    runsuccess=0;
else
    sh $SHELLSCRIPTS/container-exists.sh activemq;
    exists=$?;

    if [ $exists -eq 0 ]
    then
        docker start activemq;
    else
        docker run -d \
        --name activemq \
        -p 8161:8161 \
        -p 61616:61616 \
        --restart "unless-stopped" \
        webcenter/activemq;
    fi
fi
