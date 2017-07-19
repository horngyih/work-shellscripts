#!/bin/bash

function usage
{
    echo "usage: backup-database <databasename> [ -h|--host <db_host> ][ -p|--port <db_port> ][ -U|--user <db_user> ][ -fp|--path <path> ][ -f|--file <filename>][ -z zip-outpu ]";
}

if [ $# -eq 0 ]
then
    echo "No arguments provided";
    usage;
    exit;
fi

#Default Settings
hostname=dockerhost;
port=5432;
username=postgres;
path=$DOCKER_ENV/backups/postgres;
zipped=0;

#Default Environment Settings
if [ ! -z $DB_HOST ]
then
    hostname=$DB_HOST;
else
    echo 'No DB_HOST set defaulting to' $hostname;
fi

if [ ! -z $DB_PORT ]
then
    port=$DB_PORT;
else
    echo 'No DB_PORT set defaulting to' $port;
fi

if [ ! -z $DB_USER ]
then
    username=$DB_USER;
else
    echo 'No DB_USER set defaulting to' $username;
fi

# Read Database Name
database=$1;
shift;

# Configure output filename
filename=$(date +%Y%m%d_%H%M)-$hostname-$database-backup.sql;

# Read User Passed in Arguments
while [ "$1" != "" ]; do
    case $1 in
        -h | --host )
            shift
            hostname=$1
            ;;
        -U | --user )
            shift
            username=$1
            ;;
        -fp | --path )
            shift
            path=$1
            ;;
        -f | --file )
            shift
            filename=$1
            ;;
        -p | --port )
            shift
            port=$1
            ;;
        -z | --zipped )
            shift
            zipped=1;
    esac
    shift
done


echo 'Backup database' $database $username'@'$hostname 'to ' $path/$filename;
pg_dump -U $username -W -d $database -h $hostname -f $path/$filename;
if [ $? -eq 0 ]
then
    echo 'Backup complete' $(date +'%Y%m%d %H:%M');
    if [ $zipped -eq 1 ]
    then
        gzip $path/$filename;
    fi
fi

