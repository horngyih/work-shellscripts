#!/bin/bash

sh $SHELLSCRIPTS/container-running.sh memcached;
running=$?

if [ $running -eq 0 ]
then
    echo "Stopping Memcached Docker";
    docker stop memcached;
    stopped=$?
    echo "Stopped" $(date +'%Y-%m-%d %H:%M');
fi

if [ $1 = '-d' ]
then
    sh $SHELLSCRIPTS/container-exists.sh memcached;
    exists=$?
    if [ $exists -eq 0 ]
    then
        echo 'Destroying container';
        docker rm -f memcached;
        destroyed=$?
        if [ $destroyed -eq 0 ]
        then
            echo 'Destroyed' $(date +'%Y-%m-%d %H:%m')
        else
            echo 'Unable to destroy memcached container';
        fi
    else
        echo 'Memcached container does not exist';
    fi
fi
