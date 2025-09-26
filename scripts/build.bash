#!/bin/bash

# Define colors and symbols.
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
CHECK="✓"
CROSS="✗"

echo "🚀 Starting build script with Tailwind CSS v3.4.0..."
echo

# Get the project root directory (one level up from scripts/)
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "📁 Project root: $PROJECT_ROOT"
echo

# Change to project root directory
cd "$PROJECT_ROOT"

# Since DigitalOcean will build using Linux, but you develop on macOS, download both:
echo "📦 Downloading tailwindcss for linux..."
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/download/v3.4.0/tailwindcss-linux-x64
echo -e "${GREEN}${CHECK} Downloaded tailwindcss for linux."

echo "📦 Downloading tailwindcss for mac-os..."
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/download/v3.4.0/tailwindcss-macos-arm64
echo -e "${GREEN}${CHECK} Downloaded tailwindcss for mac-os."

# Assign permissions.
echo "🔒 Assigning permissions to tailwindcss files..."
chmod +x tailwindcss-linux-x64
chmod +x tailwindcss-macos-arm64
echo -e "${GREEN}${CHECK} Assigned permissions to tailwindcss files."
echo

# Determine the correct binary to use
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if [[ $(uname -m) == "arm64" ]]; then
        echo "🍎 Using macOS ARM64 binary..."
        TAILWIND_BINARY="./tailwindcss-macos-arm64"
    else
        echo "🍎 Using macOS Intel binary..."
        TAILWIND_BINARY="./tailwindcss-macos-x64"
    fi
else
    # Linux
    echo "🐧 Using Linux binary..."
    TAILWIND_BINARY="./tailwindcss-linux-x64"
fi

# Check if the binary exists and is executable
if [ ! -f "$TAILWIND_BINARY" ]; then
    echo -e "${RED}❌ Tailwind binary not found: $TAILWIND_BINARY${NC}"
    echo "Please download the correct binary for your system."
    exit 1
fi

if [ ! -x "$TAILWIND_BINARY" ]; then
    echo "Making binary executable..."
    chmod +x "$TAILWIND_BINARY"
fi

echo "☕️ Creating 'dist' directory..."
mkdir -p dist
echo -e "${GREEN}${CHECK} Created 'dist' directory."
echo

echo "📦 Building CSS with Tailwind v3.4.0..."
"$TAILWIND_BINARY" -i src/input.css -o dist/styles.css --content "src/*.html" --minify
echo -e "${GREEN}${CHECK} CSS built successfully."
echo

echo "📄 Copying HTML files to 'dist' directory..."
cp src/*.html dist/
echo -e "${GREEN}${CHECK} Copied HTML files to 'dist' directory."

# Copy other assets (if you have images, etc.)
echo "📄 Copying asset files to 'dist' directory..."
cp -r src/assets/ dist/ 2>/dev/null || true
echo -e "${GREEN}${CHECK} Copied asset files to 'dist' directory."
echo

echo "📊 Listing files in the 'dist/' directory..."
ls -la dist/
echo

# Check for specific classes
echo "🔍 Checking if Tailwind classes are included:"
if grep -q "\.text-lg" dist/styles.css; then
    echo -e "${GREEN}✅ 'text-lg' class found in dist/styles.css${NC}"
else
    echo -e "${RED}❌ 'text-lg' class NOT found in dist/styles.css${NC}"
fi

if grep -q "\.text-gray-700" dist/styles.css; then
    echo -e "${GREEN}✅ 'text-gray-700' class found in dist/styles.css${NC}"
else
    echo -e "${RED}❌ 'text-gray-700' class NOT found in dist/styles.css${NC}"
fi

echo
echo -e "${GREEN}${CHECK} Build completed successfully!${NC}"
echo "🎉 Your static site is ready for deployment to DigitalOcean!"