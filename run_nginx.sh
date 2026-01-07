#!/bin/sh
set -e

envsubst '${APP_HOST} ${APP_PORT} ${LISTEN_PORT} ${SERVER_NAME}' \
  < /etc/nginx/default.conf.tpl \
  > /etc/nginx/conf.d/default.conf

nginx -g "daemon off;"
