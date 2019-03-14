#!/bin/bash
docker run -it --rm --add-host=dockerhost:$DOCKERHOST -e EDITOR=vim horngyih/dockerized-pgcli "$@"
