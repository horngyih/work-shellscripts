#! /bin/sh
docker run -d --rm --name cockpit -p 8989:80 -v /docker-env/data/cockpit/config:/var/www/html/config --link cockpit-mongodb:mongodb --mount source=cockpit-storage,target=/var/www/html/storage agentejo/cockpit
