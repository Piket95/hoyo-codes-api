#!/bin/bash

# List of required environment variables
REQUIRED_ENV_VARS=(DB_HOST DB_PORT DB_USER DB_PASSWORD DB_NAME)

if [ -z "${DB_PORT}" ]; then
  export DB_PORT=3306
fi

# Check if each required variable is set
for VAR in "${REQUIRED_ENV_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
        echo "Error: Environment variable $VAR is not set"
        exit 1
    fi
done

echo "DATABASE_URL=mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}" > .env

# setup project
prisma migrate dev -n prod

tail -f /dev/null