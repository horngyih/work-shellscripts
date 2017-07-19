#!/bin/sh

if [ ! -z $1 ]
then
    targetwar=$1.war

    if [ -z $2 ]
    then
        targetwar=$1.war
    else
        targetwar=$2
    fi

    echo 'Deploying to' $DOCKER_WEBAPPS
    if [ -e $DOCKER_WEBAPPS/$1 ]
    then
        echo 'Clearing deployed folder' $DOCKER_WEBAPPS/$1;
        rm -rf $DOCKER_WEBAPPS/$1;
    fi

    if [ -e $DOCKER_WEBAPPS/$1.war ]
    then
        echo 'Clearing deployed war file' $DOCKER_WEBAPPS/$1;
        rm -rf $DOCKER_WEBAPPS/$1.war;
    else
        echo 'No warfile deployed';
    fi

    if [ -e target/$targetwar ]
    then
        cp target/$targetwar $DOCKER_WEBAPPS/$1.war
        if [ $? -eq 0 ]
        then
            echo 'Deployed' $(date +'%Y-%m-%d %H:%M');
        else
            echo 'Failed to deploy';
        fi
    else
        echo 'Cannot find target/'$targetwar.war;
    fi

else
    if [ -z $1 ]
    then
        echo 'No target package specified'
    fi

    echo 'Usage: deploy-docker <pacakge-name> [ <package-target-war> ]';
fi
