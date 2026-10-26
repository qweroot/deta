FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    wget gnupg git unzip xvfb chromium \
    fonts-liberation \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/ismoiloffS/EzSolver.git /app
WORKDIR /app

RUN pip install --no-cache-dir nodriver fastapi uvicorn

ENV CHROME_PATH=/usr/bin/chromium

EXPOSE 8191
CMD Xvfb :99 -screen 0 1024x768x24 & export DISPLAY=:99 && python service.py
