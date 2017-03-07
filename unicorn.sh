#!/bin/sh

#
# Move file to /etc/init.d and chmod file to executable
#

set -u
set -e

USER=deploy
GEM_HOME="/var/www/html/test_deploy_v2/shared/bundle"
APP_ROOT="/var/www/html/test_deploy_v2/current"
SET_PATH="export GEM_HOME=$GEM_HOME"

PID="$APP_ROOT/tmp/pids/unicorn.pid"
ENV="production"
CMD="$SET_PATH; cd $APP_ROOT && bundle exec unicorn -D -E $ENV -c $APP_ROOT/config/unicorn/production.rb"
old_pid="$PID.oldbin"

$SET_PATH || exit 1

sig () {
  test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
  test -s $old_pid && kill -$1 `cat $old_pid`
}

case $1 in
start)
  sig 0 && echo >&2 "Already running" && exit 0
  su - $USER -c "$CMD"
  ;;
stop)
  sig QUIT && exit 0
  echo >&2 "Not running"
  ;;
force-stop)
  sig TERM && exit 0
  echo >&2 "Not running"
  ;;
restart|reload)
  sig HUP && echo reloaded OK && exit 0
  echo >&2 "Couldn't reload, starting '$CMD' instead"
  su - $USER -c "$CMD"
  ;;
upgrade)
  sig USR2 && echo upgraded OK && exit 0
  echo >&2 "Couldn't upgrade, starting '$CMD' instead"
  su - $USER -c "$CMD"
  ;;
rotate)
  sig USR1 && echo rotated logs OK && exit 0
  echo >&2 "Couldn't rotate logs" && exit 1
  ;;
*)
  echo >&2 "Usage: $0 <start|stop|restart|upgrade|rotate|force-stop>"
  exit 1
  ;;
esac
