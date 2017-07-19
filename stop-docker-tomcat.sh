#!/bin/sh

sh /d/work/scripts/shellscripts/container-running.sh tomcat-dev;
running=$?

if [ $running -eq 0 ]
then
	echo "Tomcat Dev Docker is running";
	echo "Stopping...";
	docker stop tomcat-dev && docker rm tomcat-dev;
	exit 0;
else
	echo "Tomcat Dev Docker is not running";
	exit -1;
fi
