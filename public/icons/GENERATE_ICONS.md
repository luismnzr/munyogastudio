# PWA Icons Generation Guide

## Required Icons

Your PWA needs the following icon sizes in the `/public/icons/` directory:

- icon-72x72.png
- icon-96x96.png
- icon-128x128.png
- icon-144x144.png
- icon-152x152.png
- icon-192x192.png
- icon-384x384.png
- icon-512x512.png

## How to Generate Icons

### Option 1: Using online tool (Easiest)
1. Visit https://www.pwabuilder.com/imageGenerator
2. Upload your logo: `app/assets/images/mun_logo.svg`
3. Download the generated icons
4. Place them in `/public/icons/`

### Option 2: Using ImageMagick (Command line)
If you have ImageMagick installed, run:

```bash
# From the project root
cd public/icons
for size in 72 96 128 144 152 192 384 512; do
  convert ../../app/assets/images/mun_logo.svg -resize ${size}x${size} icon-${size}x${size}.png
done
```

### Option 3: Manual creation
1. Open `app/assets/images/mun_logo.svg` in a design tool (Figma, Sketch, Illustrator)
2. Export as PNG at each required size
3. Save to `/public/icons/` with the naming convention above

## Design Guidelines
- Use a square canvas (1:1 ratio)
- Ensure the logo is centered
- Add padding around the logo (safe zone of ~10%)
- Use a solid background color (#253938 recommended to match theme)
- Icons should look good on both light and dark backgrounds

## Current Status
The manifest and service worker are configured to use these icons once generated.
