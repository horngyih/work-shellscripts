#! /bin/sh
docker run -d --rm --name cockpit-mongodb --mount source=mongo-cockpit,target=/data/db -p 27017:27017 mongo
