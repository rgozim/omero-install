#!/bin/bash
APACHECMD=${1:-apache}
set -e -u -x

source settings.env

#start-config
OMERO.server/bin/omero config set omero.web.application_server wsgi
OMERO.server/bin/omero web config $APACHECMD --http "$OMERO_WEB_PORT" > OMERO.server/apache.conf.tmp
OMERO.server/bin/omero web syncmedia
