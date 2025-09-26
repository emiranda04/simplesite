#!/bin/bash

# Script is in scripts/, so go up one level to project root
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WELL_KNOWN_DIR="$PROJECT_ROOT/.well-known"
CONFIG_FILE="$WELL_KNOWN_DIR/deployment-configuration"

echo "📁 Project root: $PROJECT_ROOT"
echo "📁 Well-known dir: $WELL_KNOWN_DIR"

# Create the .well-known directory in project root
mkdir -p "$WELL_KNOWN_DIR"

# Create the deployment configuration file
cat > "$CONFIG_FILE" << 'EOF'
{
    "static_site": {
        "build_command": "bash scripts/build.bash",
        "output_dir": "dist"
    }
}
EOF

echo "✅ Created $CONFIG_FILE"

# Verify
echo "📁 Contents of .well-known:"
ls -la "$WELL_KNOWN_DIR"