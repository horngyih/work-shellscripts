#!/bin/sh

ps_output="";
if [ -z $1 ]
then
	echo "No specified docker target";
    echo "Usage : container-running.sh <docker-container-name>";
	exit -1;
else
	ps_output=$(docker ps | grep -c $1);
	if [ $ps_output -gt 0 ]
	then
        echo $1 "is running";
		exit 0;
	else
        echo $1 "is not running";
		exit -1;
	fi
fi

