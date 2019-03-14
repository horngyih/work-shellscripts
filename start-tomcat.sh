#! /bin/sh

JPDA_ADDRESS=8000;
JPDA_TRANSPORT=dt_socket;
CATALINA_OPTS="-server -Xms256M -Xmx1025M -XX:PermSize=150m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -Xnoclassgc -Xconcgc -Xmn64m -Dcom.sun.xml.ws.transport.local.LocalTransportPipe.dump=true";

sh check-port-listener.sh 8080;
tomcat_running=$?;

function startTomcatDev
{
    CATALINA_OPTS=$CATALINA_OPTS exec $CATALINA_HOME/bin/catalina.sh jpda start; 
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
    esac
done

if [ $tomcat_running -eq 0 ]
then
    echo 'Tomcat already running';
else
    echo 'Tomcat not running';
    startTomcatDev;
fi

if [ $tail -eq 1 ]
then
    tail -f $CATALINA_HOME/logs/catalina.out;
fi
