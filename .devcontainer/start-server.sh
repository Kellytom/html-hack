#!/bin/bash

mkdir -p /tmp/logs

echo "Starting server at $(date)" > /tmp/logs/server.log

cd /workspaces/html && \
nohup bash -c "npm start 2>&1 | tee -a /tmp/logs/server.log" > /dev/null 2>&1 &

echo $! > /tmp/logs/server.pid

echo "Server process started with PID $(cat /tmp/logs/server.pid)"
echo "Monitor with: tail -f /tmp/logs/server.log"
