#!/bin/bash

# start necessary/useful services
service cron start
service syslog-ng start

# list of required environment variables
REQUIRED_ENV_VARS=(DB_HOST DB_PORT DB_USER DB_PASSWORD DB_NAME)

if [ -z "${DB_PORT}" ]; then
  export DB_PORT=3306
fi

# check if each required environment variable is set
for VAR in "${REQUIRED_ENV_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
        echo "Error: Environment variable $VAR is not set"
        exit 1
    fi
done

echo "DATABASE_URL=mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}" > .env

# setup project
prisma generate
prisma migrate dev -n prod

# initial database fill
python update.py

# api runs under port 1078
parallel ::: "tail -f /var/log/cron.log" "python run.py"
