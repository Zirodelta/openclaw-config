# OpenClaw Config for Zirodelta

Multi-tenant OpenClaw Gateway for Zirodelta's AI trading assistant.

## Architecture

```
Zirodelta Users → Frontend → Backend → OpenClaw Gateway → Claude/GPT
                                              ↓
                                     Tools (via zirodelta API)
```

Each user gets their own isolated session with persistent memory.

## Deployment (Fly.io)

### Prerequisites

1. Install Fly CLI: `brew install flyctl`
2. Login: `fly auth login`

### First-time Setup

```bash
# Create the app
fly launch --no-deploy

# Set secrets
fly secrets set OPENCLAW_GATEWAY_TOKEN="your-secure-token"
fly secrets set ANTHROPIC_API_KEY="sk-ant-..."
fly secrets set ZIRODELTA_API_URL="https://api.zirodelta.xyz"

# Deploy
fly deploy
```

### Updates

```bash
fly deploy
```

### Logs

```bash
fly logs
```

## Configuration

- `config.yaml` - Main OpenClaw Gateway config
- `fly.toml` - Fly.io deployment config
- `Dockerfile` - Container build

## Environment Variables

| Variable | Description |
|----------|-------------|
| `OPENCLAW_GATEWAY_TOKEN` | Auth token for backend to call Gateway |
| `ANTHROPIC_API_KEY` | Claude API key |
| `ZIRODELTA_API_URL` | Backend API base URL |

## Backend Integration

The zirodelta backend should call:

```
POST https://openclaw-zirodelta.fly.dev/v1/chat/completions
Headers:
  Authorization: Bearer ${OPENCLAW_GATEWAY_TOKEN}
  x-openclaw-session-key: ziro:user:${user_id}
  x-openclaw-agent-id: delta
Body:
  { "model": "openclaw:delta", "messages": [...], "stream": true }
```

## Local Development

```bash
# Install OpenClaw
npm install -g openclaw

# Run locally
ANTHROPIC_API_KEY=sk-ant-... openclaw gateway --config config.yaml
```

## Session Isolation

Each user gets a unique session key: `ziro:user:{user_id}`

This ensures:
- Separate conversation history
- Separate memory/context
- No data leakage between users

## Tools Available

| Tool | Description |
|------|-------------|
| `getTopOpportunities` | List best funding rate arbitrage opportunities |
| `getPairDetail` | Get detailed analysis of a trading pair |
| `getPortfolioSummary` | View user's portfolio (requires auth) |
| `executeHedge` | Execute a hedge trade (requires auth) |
| `navigateTo` | Navigate user to a page in the app |
