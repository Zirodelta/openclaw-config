#!/bin/bash
# First-time setup for OpenClaw Gateway on Fly.io

set -e

echo "🔧 Setting up OpenClaw Gateway on Fly.io..."
echo ""

# Check if fly is installed
if ! command -v fly &> /dev/null; then
    echo "❌ Fly CLI not found."
    echo "   Install with: brew install flyctl"
    echo "   Or: curl -L https://fly.io/install.sh | sh"
    exit 1
fi

# Check if logged in
if ! fly auth whoami &> /dev/null; then
    echo "📝 Please log in to Fly.io..."
    fly auth login
fi

echo ""
echo "🆕 Creating Fly app..."
fly apps create openclaw-zirodelta --org personal 2>/dev/null || echo "App already exists"

echo ""
echo "🔐 Setting secrets..."
echo ""
echo "You need to set the following secrets:"
echo ""

# Prompt for secrets
read -p "Enter OPENCLAW_GATEWAY_TOKEN (generate a secure random string): " GATEWAY_TOKEN
read -p "Enter ANTHROPIC_API_KEY (sk-ant-...): " ANTHROPIC_KEY
read -p "Enter ZIRODELTA_API_URL (default: https://api.zirodelta.xyz): " API_URL

API_URL=${API_URL:-https://api.zirodelta.xyz}

echo ""
echo "Setting secrets..."
fly secrets set \
    OPENCLAW_GATEWAY_TOKEN="$GATEWAY_TOKEN" \
    ANTHROPIC_API_KEY="$ANTHROPIC_KEY" \
    ZIRODELTA_API_URL="$API_URL"

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Review config.yaml"
echo "  2. Run: ./scripts/deploy.sh"
echo ""
echo "Or deploy manually: fly deploy"
