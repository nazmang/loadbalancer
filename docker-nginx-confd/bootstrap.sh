#!/bin/bash
set -eo pipefail

TOML=/etc/confd/conf.d/nginx.toml

if [ -z "$CONFD_BACKEND" ]; then
  echo "CONFD_BACKEND environment variable not set. Exiting..."
  exit 1
fi

if [ "$CONFD_BACKEND" == "etcd" ]; then
  if [ -z "$ETCD_HOST" ]; then
    echo "ETCD_HOST environment variable not set. Exiting..."
    exit 1
  fi

  if [ -z "$ETCD_PORT" ]; then
    echo "ETCD_PORT environment variable not set. Exiting..."
    exit 1
  fi
  CONFD_PARAMS="-backend etcd -node $ETCD_HOST:$ETCD_PORT"
else
  echo "confd backend not supported: $CONFD_BACKEND"
  exit 1
fi

echo "[nginx] starting nginx service..."
/usr/sbin/service nginx start
sleep 2

if [ $(ps -ef | grep -v grep | grep nginx | wc -l) == 0 ]; then
  echo "nginx not running. Exiting..."
  exit 1
fi

echo "[etcd] trying to connect $CONFD_PARAMS"

# Launch it one time to see if it configured correctly
#confd -onetime $CONFD_PARAMS -config-file ${TOML}
#if [ $? != 0 ]; then
#  echo "Error running confd"
#  exit 1
#fi
sleep 2
echo "[nginx] Starting confd and monitoring etcd for changes..."
#confd -interval 10 $CONFD_PARAMS -config-file ${TOML}
