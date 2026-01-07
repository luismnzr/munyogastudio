// PWA Install Prompt
let deferredPrompt;
let installButton;

window.addEventListener('beforeinstallprompt', (e) => {
  // Prevent the mini-infobar from appearing on mobile
  e.preventDefault();
  // Stash the event so it can be triggered later
  deferredPrompt = e;
  // Show install button
  showInstallPromotion();
});

function showInstallPromotion() {
  // Create install button if it doesn't exist
  if (!installButton) {
    installButton = document.createElement('div');
    installButton.id = 'pwa-install-prompt';
    installButton.innerHTML = `
      <div style="
        position: fixed;
        bottom: 20px;
        left: 50%;
        transform: translateX(-50%);
        background: #253938;
        color: white;
        padding: 15px 20px;
        border-radius: 30px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        display: flex;
        align-items: center;
        gap: 15px;
        z-index: 1000;
        max-width: 90%;
        animation: slideUp 0.3s ease;
      ">
        <span style="flex: 1; font-size: 14px;">
          📱 Instala Mun Yoga en tu dispositivo
        </span>
        <button id="install-button" style="
          background: #ee7756;
          color: white;
          border: none;
          padding: 10px 20px;
          border-radius: 20px;
          cursor: pointer;
          font-size: 14px;
          font-weight: 600;
        ">
          Instalar
        </button>
        <button id="dismiss-button" style="
          background: transparent;
          color: white;
          border: none;
          cursor: pointer;
          font-size: 20px;
          padding: 0 5px;
        ">
          ×
        </button>
      </div>
    `;

    document.body.appendChild(installButton);

    // Install button click
    document.getElementById('install-button').addEventListener('click', async () => {
      if (deferredPrompt) {
        deferredPrompt.prompt();
        const { outcome } = await deferredPrompt.userChoice;
        console.log(`User response to the install prompt: ${outcome}`);
        deferredPrompt = null;
        hideInstallPromotion();
      }
    });

    // Dismiss button click
    document.getElementById('dismiss-button').addEventListener('click', () => {
      hideInstallPromotion();
      // Don't show again for this session
      sessionStorage.setItem('pwa-install-dismissed', 'true');
    });
  }

  // Only show if not dismissed in this session
  if (!sessionStorage.getItem('pwa-install-dismissed')) {
    installButton.style.display = 'block';
  }
}

function hideInstallPromotion() {
  if (installButton) {
    installButton.style.display = 'none';
  }
}

window.addEventListener('appinstalled', () => {
  console.log('PWA was installed');
  hideInstallPromotion();
  deferredPrompt = null;
});

// Add slide up animation
const style = document.createElement('style');
style.textContent = `
  @keyframes slideUp {
    from {
      transform: translateX(-50%) translateY(100px);
      opacity: 0;
    }
    to {
      transform: translateX(-50%) translateY(0);
      opacity: 1;
    }
  }
`;
document.head.appendChild(style);
