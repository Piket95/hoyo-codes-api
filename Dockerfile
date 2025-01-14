FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    postgresql \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# PostgreSQL Konfiguration
USER postgres
RUN /etc/init.d/postgresql start && \
    createdb hoyo-codes

# Zurück zum root User
USER root

# Python Requirements installieren (falls benötigt)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Start-Script kopieren und ausführbar machen
# COPY start.sh /start.sh
# RUN chmod +x /start.sh

# CMD ["/start.sh"]
