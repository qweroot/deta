FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    wget gnupg git xvfb \
    fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 \
    libatk1.0-0 libcups2 libdbus-1-3 libdrm2 libgbm1 libgtk-3-0 \
    libnspr4 libnss3 libx11-xcb1 libxcomposite1 libxdamage1 libxfixes3 \
    libxkbcommon0 libxrandr2 xdg-utils ca-certificates \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list' \
    && apt-get update && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/ismoiloffS/EzSolver.git /app/ezsolver
WORKDIR /app

COPY main.py /app/main.py

RUN pip install --no-cache-dir nodriver fastapi uvicorn pydantic

CMD Xvfb :99 -screen 0 1024x768x24 & \
    export DISPLAY=:99 && \
    cd /app/ezsolver && python service.py & \
    cd /app && uvicorn main:app --host 0.0.0.0 --port 8000
