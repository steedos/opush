#!/bin/sh

# start redis
redis-server /usr/local/etc/redis/redis.conf
# start pushd
coffee pushd.coffee