FROM python:3.10-slim-bookworm

RUN apt-get update && apt-get install -y \
    wget gnupg git unzip xvfb \
    fonts-liberation \
    libgl1 libglx-mesa0 libglu1-mesa \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 \
    libcups2 libdbus-1-3 libdrm2 libgbm1 libgtk-3-0 \
    libnspr4 libnss3 libx11-xcb1 libxcomposite1 libxdamage1 \
    libxfixes3 libxkbcommon0 libxrandr2 xdg-utils \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y /tmp/chrome.deb \
    && rm /tmp/chrome.deb

RUN git clone https://github.com/ismoiloffS/EzSolver.git /app
WORKDIR /app

RUN pip install --no-cache-dir nodriver fastapi uvicorn

ENV CHROME_PATH=/usr/bin/google-chrome
ENV DISPLAY=:99

CMD Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset & \
    export DISPLAY=:99 && \
    sed -i 's/uc.start()/uc.start(browser_args=["--no-sandbox", "--disable-dev-shm-usage", "--disable-blink-features=AutomationControlled", "--window-size=1920,1080"])/g' service.py && \
    exec python service.py
