#!/usr/bin/env bash

set -e
set -x

/app/startup/10-boot-conf

exec supervisord -c /app/supervisord.conf

