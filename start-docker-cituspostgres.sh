#!/bin/bash
container=postgres
imagename=citusdata/citus

sh $SHELLSCRIPTS/container-running.sh $container
running=$?

if [ $running -eq 0 ]
then
    echo "$container Docker is already running";
    runsuccess=0;
else
    sh $SHELLSCRIPTS/container-exists.sh $container;
    exists=$?;

    if [ $exists -eq 0 ]
    then
        docker start $container;
    else
        docker run -d \
        --name $container \
        -p 5432:5432 \
        -e POSTGRES_USER=postgres \
        -e POSTGRES_PASSWORD=ubi123 \
        -e POSTGRES_DB=Mobile \
        --restart "unless-stopped" \
        $imagename;
    fi
fi
