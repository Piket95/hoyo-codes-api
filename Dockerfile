FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    postgresql \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# PostgreSQL Konfiguration
USER postgres
RUN /etc/init.d/postgresql start && \
    createdb hoyo-codes
RUN psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'docker';"

# Zurück zum root User
USER root

# Python Requirements installieren (falls benötigt)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY start.sh /.start.sh
RUN chmod +x ./start.sh

# make a .env file
RUN echo -e "DATABASE_URL=postgresql://postgres:docker@localhost:5432/hoyo-codes\nGENSHIN_COOKIES=" > test.env

# setup project
RUN prisma migrate dev
RUN python update.py

# TODO: Add cron jobs for update

CMD ["./start.sh"]
