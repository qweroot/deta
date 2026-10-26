FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    wget gnupg git unzip xvfb chromium \
    fonts-liberation \
    libgl1-mesa-dri libglx-mesa0 libgl1-mesa-glx \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/ismoiloffS/EzSolver.git /app
WORKDIR /app

RUN pip install --no-cache-dir nodriver fastapi uvicorn

RUN sed -i 's/uc.start(/uc.start(browser_args=["--no-sandbox", "--ignore-gpu-blocklist", "--enable-webgl", "--use-gl=swiftshader"], /g' service.py || true

ENV CHROME_PATH=/usr/bin/chromium

CMD Xvfb :99 -screen 0 1024x768x24 +extension GLX +render -noreset & export DISPLAY=:99 && exec python service.py
