#!/bin/bash
et -eu

envsubst '${HOST_IP}' < /etc/nginx/sites-available/default.template > /etc/nginx/sites-available/default

exec "$@"
