const prerender = require('./lib');
const puppeteer = require('puppeteer');

// Determine Chrome path based on environment
const useSystemChrome = process.env.USE_SYSTEM_CHROME === 'true';
const chromeLocation = useSystemChrome
    ? '/usr/bin/google-chrome' // System Chrome path in Docker
    : puppeteer.executablePath(); // Puppeteer Chrome path for local

console.log(`Using Chrome at: ${chromeLocation}`);

// Initialize Prerender server
const server = prerender({
    chromeLocation: chromeLocation,
    port: 4000,
    chromeFlags: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu',
        '--headless',
        '--remote-debugging-port=9222', // Ensure remote debugging is enabled
    ],
});

// Middleware setup
server.use(prerender.sendPrerenderHeader());
server.use(prerender.browserForceRestart());
server.use(prerender.addMetaTags());
server.use(prerender.removeScriptTags());
server.use(prerender.httpHeaders());

// Start the server
server.start();
