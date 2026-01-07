# Progressive Web App (PWA) Implementation

## Overview

Mun Yoga Studio has been converted into a Progressive Web App! This allows users to install the app on their mobile devices and use it like a native app.

## What's Been Implemented

### ✅ Core PWA Features

1. **Web App Manifest** (`/public/manifest.json`)
   - App name, colors, and display mode
   - Icon definitions for various sizes
   - Standalone display mode for app-like experience

2. **Service Worker** (`/public/service-worker.js`)
   - Offline support with caching strategy
   - Network-first approach for dynamic content
   - Cache fallback for offline scenarios
   - Automatic cache cleanup

3. **PWA Meta Tags** (in `app/views/layouts/application.html.erb`)
   - Apple-specific meta tags for iOS
   - Theme colors for browser chrome
   - Proper viewport configuration

4. **Install Prompt** (`app/javascript/pwa_install.js`)
   - Custom install prompt UI
   - Session-based dismissal
   - Automatic detection of install capability

5. **Mobile UX Improvements**
   - Touch-friendly button sizes (minimum 44x44px)
   - Improved spacing and padding for mobile
   - Font sizes that prevent iOS zoom
   - Safe area insets for notched devices
   - Smooth scrolling and better touch feedback

### 📱 User Benefits

- **Install on home screen**: One-tap access like a native app
- **Offline viewing**: View cached pages without internet
- **Faster loading**: Assets cached for instant loading
- **Full-screen experience**: No browser chrome when installed
- **App-like feel**: Smooth transitions and touch interactions

## Setup Instructions

### 1. Generate PWA Icons

You need to generate icons in multiple sizes. See `/public/icons/GENERATE_ICONS.md` for detailed instructions.

**Quick option**: Visit https://www.pwabuilder.com/imageGenerator
- Upload `app/assets/images/mun_logo.svg`
- Download the generated icons
- Place them in `/public/icons/`

**Required sizes:**
- 72x72, 96x96, 128x128, 144x144, 152x152, 192x192, 384x384, 512x512

### 2. Deploy to Production

PWAs require HTTPS to work. Ensure your production environment has:
- SSL certificate installed
- HTTPS enabled
- Service worker accessible at `/service-worker.js`

### 3. Test the PWA

See the Testing Guide section below.

## Testing Guide

### Desktop Testing (Chrome/Edge)

1. Start your Rails server: `rails s`
2. Open Chrome DevTools (F12)
3. Go to **Application** tab
4. Check:
   - **Manifest**: Should show app details and icons
   - **Service Workers**: Should show registered worker
   - **Cache Storage**: Should show cached resources after visiting pages

5. Test install prompt:
   - Look for install icon in address bar
   - Click to install
   - App should open in standalone window

6. Test offline:
   - Visit a few pages while online
   - Go to **Network** tab → Select "Offline"
   - Reload pages - they should load from cache
   - Try new pages - should show offline page

### Mobile Testing (iOS)

1. Deploy to a server with HTTPS (or use ngrok for local testing)
2. Open Safari on iPhone/iPad
3. Navigate to your site
4. Tap the **Share** button
5. Tap **Add to Home Screen**
6. Name it and tap **Add**
7. App icon should appear on home screen
8. Launch from home screen - should open without browser chrome

**Note**: iOS has limited PWA support:
- No install prompt (manual add to home screen only)
- No push notifications
- Service worker support is improving but limited

### Mobile Testing (Android)

1. Deploy to a server with HTTPS
2. Open Chrome on Android
3. Navigate to your site
4. Look for install banner at bottom
5. Or use Chrome menu → **Install app**
6. App should install like native app
7. Launch from app drawer

**Test features:**
- Splash screen on launch
- Standalone mode (no browser UI)
- Offline functionality
- Install/uninstall flow

## PWA Audit

Use Chrome DevTools Lighthouse to audit your PWA:

1. Open DevTools → **Lighthouse** tab
2. Select **Progressive Web App** category
3. Click **Generate report**
4. Review and fix any issues

**Target scores:**
- ✅ Installable
- ✅ PWA optimized
- ✅ Works offline
- ✅ Configured for custom splash screen

## Maintenance

### Updating Cached Content

When you deploy changes, users might see old cached content. To force updates:

1. Update cache version in `service-worker.js`:
   ```javascript
   const CACHE_NAME = 'munyoga-v2'; // Increment version
   ```

2. Service worker will automatically delete old caches
3. Users will get fresh content on next visit

### Monitoring

Monitor these metrics:
- Install conversion rate
- Offline usage patterns
- Cache hit rates
- Service worker errors (check browser console)

## Browser Support

| Feature | Chrome/Edge | Safari iOS | Firefox | Samsung |
|---------|------------|------------|---------|---------|
| Install | ✅ | ⚠️ Manual | ✅ | ✅ |
| Offline | ✅ | ✅ | ✅ | ✅ |
| Push | ✅ | ❌ | ✅ | ✅ |
| Standalone | ✅ | ✅ | ✅ | ✅ |

⚠️ = Partial support
❌ = Not supported
✅ = Full support

## Troubleshooting

### Install Prompt Not Showing

- Must be served over HTTPS
- User hasn't installed before
- Must have valid manifest
- Must have registered service worker
- Chrome: User must visit site twice with 5+ minute gap

### Service Worker Not Registering

- Check console for errors
- Verify `/service-worker.js` is accessible
- Clear browser cache and retry
- Ensure no syntax errors in service worker

### Icons Not Showing

- Generate all required icon sizes
- Place in `/public/icons/` directory
- Verify paths in `manifest.json`
- Clear cache and reinstall app

### Offline Page Not Working

- Visit some pages while online first (to cache them)
- Check service worker is active
- Verify `/offline.html` is cached
- Check network tab for service worker interception

## Next Steps

Once PWA is working, consider adding:

1. **Push Notifications** (Android only)
   - Remind users of upcoming classes
   - Notify when classes open up
   - Cancellation confirmations

2. **Background Sync**
   - Queue reservations when offline
   - Sync when connection restored

3. **Web Share API**
   - Share classes with friends
   - Share reservations

4. **Better Offline Experience**
   - Show cached reservations
   - Queue actions for when online

5. **App Shortcuts**
   - Quick actions from home screen icon
   - Jump to calendar, reservations, etc.

## Resources

- [MDN PWA Guide](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)
- [web.dev PWA Checklist](https://web.dev/pwa-checklist/)
- [PWA Builder](https://www.pwabuilder.com/)
- [Can I Use - PWA Features](https://caniuse.com/?search=service%20worker)

## Support

If you encounter issues with the PWA implementation, check:
1. Browser console for errors
2. Application tab in DevTools
3. Lighthouse PWA audit report
4. This documentation's troubleshooting section
