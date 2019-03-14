#! /bin/sh

sh check-port-listener.sh 8080;
tomcat_running=$?;

function stopTomcatDev
{
    exec $CATALINA_HOME/bin/catalina.sh stop; 
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
    echo 'Stopping Tomcat';
    stopTomcatDev;
else
    echo 'Tomcat not running';
fi

if [ $tail -eq 1 ]
then
    tail -f $CATALINA_HOME/logs/catalina.out;
fi
