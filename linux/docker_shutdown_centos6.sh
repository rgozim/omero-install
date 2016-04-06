#!/bin/bash
# All that's needed to get a clean shutdown of the docker container

PGVER=${PGVER:-pg94}
if [ "$PGVER" = "pg94" ]; then
	service postgresql-9.4 stop
elif [ "$PGVER" = "pg94" ]; then
	service postgresql-9.5 stop
fi
