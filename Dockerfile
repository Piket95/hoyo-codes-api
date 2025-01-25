FROM python:3.13-slim

RUN apt-get update && apt-get install cron parallel syslog-ng -y && rm -rf /var/lib/apt/lists/*

ENV GENSHIN_COOKIES=""

WORKDIR /app

# Copy project files into container
COPY . .

# Python Requirements installieren (falls benötigt)
RUN pip install --no-cache-dir -r requirements.txt

# TODO: Add cron jobs for update
COPY hoyo-codes-api-cron /etc/cron.d/
RUN chmod 0644 /etc/cron.d/hoyo-codes-api-cron
RUN crontab /etc/cron.d/hoyo-codes-api-cron
RUN touch /var/log/cron.log

EXPOSE 1078

# make entrypoint executable and run it
RUN chmod +x ./docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
