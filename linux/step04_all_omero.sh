#!/bin/bash

set -e -u -x

OMEROVER=${OMEROVER:-latest}
PY_ENV=${PY_ENV:-py27}

source `dirname $0`/settings.env
#start-install
if [ "$PY_ENV" = "py27_scl" ]; then
	#start-py27-scl
	set +u
	source /opt/rh/python27/enable
	set -u
	#end-py27-scl
fi

if [[ ! $PY_ENV = "py27_ius" ]]; then
	#start-venv
	virtualenv /home/omero/omeroenv
	/home/omero/omeroenv/bin/pip install omego==0.3.0
	#end-venv
fi

#start-install
#start-release
/home/omero/omeroenv/bin/omego download --branch $OMEROVER server
#end-release

#configure
ln -s OMERO.server-*/ OMERO.server

OMERO.server/bin/omero config set omero.data.dir "$OMERO_DATA_DIR"
OMERO.server/bin/omero config set omero.db.name "$OMERO_DB_NAME"
OMERO.server/bin/omero config set omero.db.user "$OMERO_DB_USER"
OMERO.server/bin/omero config set omero.db.pass "$OMERO_DB_PASS"
OMERO.server/bin/omero db script -f OMERO.server/db.sql --password "$OMERO_ROOT_PASS"