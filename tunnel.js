const { spawn } = require('child_process');
const path = require('path');

let activeTunnelUrl = null;
let tunnelProcess = null;

function startCloudflareTunnel(port = 5000, onUrlFound = null) {
  const exePath = path.join(__dirname, 'bin', 'cloudflared.exe');
  
  try {
    tunnelProcess = spawn(exePath, ['tunnel', '--url', `http://localhost:${port}`]);
    
    const urlRegex = /https:\/\/[a-zA-Z0-9-]+\.trycloudflare\.com/;

    function handleData(data) {
      const text = data.toString();
      const match = text.match(urlRegex);
      if (match && !activeTunnelUrl) {
        activeTunnelUrl = match[0];
        console.log(`\n====================================================`);
        console.log(`🌐 تم تفعيل الرابط الخارجي لهواتف العمال بنجاح!`);
        console.log(`📱 رابط بوابة العامل: ${activeTunnelUrl}/worker.html`);
        console.log(`====================================================\n`);
        if (typeof onUrlFound === 'function') {
          onUrlFound(activeTunnelUrl);
        }
      }
    }

    tunnelProcess.stdout.on('data', handleData);
    tunnelProcess.stderr.on('data', handleData);

    tunnelProcess.on('close', (code) => {
      console.log(`Cloudflare tunnel exited with code ${code}`);
      activeTunnelUrl = null;
    });

    return tunnelProcess;
  } catch (err) {
    console.error('Error starting cloudflared tunnel:', err.message);
    return null;
  }
}

function getActiveTunnelUrl() {
  return activeTunnelUrl;
}

module.exports = {
  startCloudflareTunnel,
  getActiveTunnelUrl
};
