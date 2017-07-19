#!/bin/sh

sh /d/work/scripts/shellscripts/container-running.sh tomcat-dev;
running=$?

if [ $running -eq 0 ]
then
	echo "Tomcat Dev Docker is already running";
    runsuccess=0;
else
    sh /d/work/scripts/shellscripts/container-exists.sh tomcat-dev;
    exists=$?;

    # Check if tomcat already exists
    if [ $exists -eq 0 ]
    then
        docker rm -f tomcat-dev;
    fi
    docker run -d \
   	--name tomcat-dev \
    -p 8080:8080 \
   	-p 8000:8000 \
    --link postgres:postgres \
   	-v /docker-env/settings:/usr/local/tomcat/settings \
    -v /docker-env/webapps:/usr/local/tomcat/webapps \
   	-v /docker-env/tomcat-logs:/usr/local/tomcat/logs \
    --link memcached:memcached \
   	--link activemq:activemq \
    -e MCICO_PATH=/usr/local/tomcat/settings \
   	-e JPDA_ADDRESS=8000 \
    -e JPDA_TRANSPORT=dt_socket \
    -e JAVA_OPTS="-server -Xms256M -Xmx1024M -XX:PermSize=150m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -Xnoclassgc -Xconcgc -Xmn64m" \
   	tomcat:7 /usr/local/tomcat/bin/catalina.sh jpda run;
    runsuccess=$?;
fi

if [ ! -z $1 ]
then
    if [ $runsuccess -eq 0 ]
    then
        if [ $1 = '-t' ]
        then
            docker logs -f tomcat-dev;
        fi
    fi
fi
