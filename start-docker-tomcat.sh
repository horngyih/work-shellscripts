#!/bin/sh

SETTINGS=/docker-env/settings
WEBAPPS=/docker-env/webapps
LOGS=/docker-env/tomcat-logs

function startTomcatDev
{
    sh /d/work/scripts/shellscripts/container-exists.sh tomcat-dev;
    exists=$?;

    if [ -z $tomcat_image ]
    then
        tomcat_image=horngyih/tomcat:7-interface;
    else
        echo "Using "$tomcat_image" Image";
    fi

    #--add-host=dockerhost:$DOCKERHOST \
    #--link postgres:postgres \
    #--link postgres-interface:interface \
    #--link memcached:memcached \
   	#--link activemq:activemq \

    # Check if tomcat already exists
    if [ $exists -eq 0 ]
    then
        docker rm -f tomcat-dev;
    fi
    docker run -d \
	--privileged \
   	--name tomcat-dev \
    -p 8080:8080 \
   	-p 8000:8000 \
    --add-host memcached:192.168.99.100 \
    --add-host activemq:192.168.99.100 \
    --add-host postgres:192.168.99.100 \
    --add-host dockerhost:192.168.99.100 \
   	-v $SETTINGS:/usr/local/tomcat/settings \
    -v $WEBAPPS:/usr/local/tomcat/webapps \
   	-v $LOGS:/usr/local/tomcat/logs \
    -e MCICO_PATH=/usr/local/tomcat/settings \
   	-e JPDA_ADDRESS=8000 \
    -e JPDA_TRANSPORT=dt_socket \
    -e JAVA_OPTS="-server -Xms256M -Xmx1024M -XX:PermSize=150m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -Xnoclassgc -Xconcgc -Xmn64m -Dcom.sun.xml.ws.transport.local.LocalTransportPipe.dump=true" \
    $tomcat_image /usr/local/tomcat/bin/catalina.sh jpda run;
    runsuccess=$?;
}

tail=0;
restart=0;

while [ "$1" != "" ]; do
    case $1 in
        -t | --tail )
            tail=1;
            shift
            ;;
        -r | --restart )
            restart=1;
            shift
            ;;
        -i | --image )
            shift
            tomcat_image=$1;
            shift
            ;;
    esac
done

sh /d/work/scripts/shellscripts/container-running.sh tomcat-dev;
running=$?

if [ $running -eq 0 ] && [ $restart -eq 0 ]
then
	echo "Tomcat Dev Docker is already running";
    runsuccess=0;
else
    startTomcatDev;
fi

if [ $tail -eq 1 ]
then
    if [ $runsuccess -eq 0 ]
    then
        docker logs -f tomcat-dev;
    fi
fi
