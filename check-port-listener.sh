#! /bin/sh
ps_output="";

if [ -z $1 ]
then
    echo "No specified port";
    echo "Usage : check-port-listener.sh <port-number>";
    exit -1;
else
    ps_output=$(netstat -na | egrep LISTENING | egrep $1 -c);
    if [ $ps_output -gt 0 ]
    then
        echo $1 "has listeners";
        exit 0;
    else
        echo $1 "has no listeners";
        exit -1;
    fi
fi
