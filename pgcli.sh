#!/bin/bash
docker run -it --rm -v /docker-env/etc/host/hosts:/etc/hosts horngyih/pgcli "$@"
