# Use a slim Node.js image
FROM node:slim AS app

# Install dependencies for Google Chrome
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxrandr2 \
    libgbm-dev \
    libxdamage1 \
    libxshmfence1 \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    xdg-utils \
    wget \
    libx11-xcb1 \
    libx11-6 \
    libxcb1 \
    libxext6 \
    libxfixes3 \
    libxrender1 \
    libxi6 \
    libxtst6 \
    libxss1 \
    libxv1 \
    libxxf86vm1 \
    libdbus-glib-1-2 \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add Google Chrome repository and install Chrome
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/src/prerender

# Copy package files
COPY package*.json ./

# Install dependencies without Puppeteer downloading Chromium
RUN PUPPETEER_SKIP_DOWNLOAD=true npm install

# Copy source files
COPY . .

# Expose port 4000
EXPOSE 4000

# Set environment variable to use system Chrome
ENV USE_SYSTEM_CHROME=true

# Start the Prerender server
CMD ["npm", "start"]
