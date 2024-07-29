#!/bin/bash

# Start Redis server
redis-server --daemonize yes

# Wait for Redis to be ready
until redis-cli ping; do
  sleep 1
done

# Start your Node.js application
node dist/src/main.js