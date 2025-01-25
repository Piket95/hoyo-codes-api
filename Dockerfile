FROM python:3.13-slim

#RUN apt-get update && rm -rf /var/lib/apt/lists/*

ENV GENSHIN_COOKIES=""

WORKDIR /app

# Copy project files into container
COPY . .

# Python Requirements installieren (falls benötigt)
RUN pip install --no-cache-dir -r requirements.txt

# TODO: Add cron jobs for update

# make entrypoint executable and run it
RUN chmod +x ./docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
