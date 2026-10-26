FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    wget gnupg git unzip xvfb chromium \
    fonts-liberation \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/ismoiloffS/EzSolver.git /app
WORKDIR /app

RUN pip install --no-cache-dir nodriver fastapi uvicorn

ENV CHROME_PATH=/usr/bin/chromium

# 关键：加上了 exec，让 python 变成主进程，容器绝不会轻易退出
CMD Xvfb :99 -screen 0 1024x768x24 & export DISPLAY=:99 && exec python service.py
