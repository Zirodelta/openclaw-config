#!/bin/bash
# Deploy OpenClaw Gateway to Fly.io

set -e

echo "🚀 Deploying OpenClaw Gateway to Fly.io..."

# Check if fly is installed
if ! command -v fly &> /dev/null; then
    echo "❌ Fly CLI not found. Install with: brew install flyctl"
    exit 1
fi

# Check if logged in
if ! fly auth whoami &> /dev/null; then
    echo "❌ Not logged in to Fly. Run: fly auth login"
    exit 1
fi

# Check required secrets
echo "📋 Checking secrets..."
SECRETS=$(fly secrets list 2>/dev/null || echo "")

if ! echo "$SECRETS" | grep -q "OPENCLAW_GATEWAY_TOKEN"; then
    echo "⚠️  Missing OPENCLAW_GATEWAY_TOKEN secret"
    echo "   Run: fly secrets set OPENCLAW_GATEWAY_TOKEN=your-secure-token"
    exit 1
fi

if ! echo "$SECRETS" | grep -q "ANTHROPIC_API_KEY"; then
    echo "⚠️  Missing ANTHROPIC_API_KEY secret"
    echo "   Run: fly secrets set ANTHROPIC_API_KEY=sk-ant-..."
    exit 1
fi

# Deploy
echo "🛫 Deploying..."
fly deploy

echo ""
echo "✅ Deployed successfully!"
echo ""
echo "📍 Gateway URL: https://openclaw-zirodelta.fly.dev"
echo "🔍 View logs: fly logs"
echo "📊 Dashboard: fly dashboard"
