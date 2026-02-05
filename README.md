# OpenClaw Config for Zirodelta

Multi-tenant OpenClaw Gateway for Zirodelta's AI trading assistant.

## Architecture

```
Zirodelta Users → Frontend → Backend → OpenClaw Gateway → Claude
                                              ↓
                                     Tools (via zirodelta API)
```

Each user gets their own isolated session with persistent memory.

## Deployment (Railway)

We use the official [OpenClaw Railway Template](https://railway.com/deploy/openclaw-railway-template).

### Current Deployment

- **URL**: `https://clawdbot-railway-template-production-80832.up.railway.app`
- **Region**: Asia (Singapore)

### Setup Steps

1. Deploy from Railway template
2. Set `SETUP_PASSWORD` in Railway Variables
3. Go to `/setup` and configure:
   - Anthropic API key
   - Enable chat completions endpoint
4. Get `OPENCLAW_GATEWAY_TOKEN` from Railway Variables

### Gateway Config

Enable the chat completions API in the gateway config:

```json
{
  "gateway": {
    "http": {
      "endpoints": {
        "chatCompletions": {
          "enabled": true
        }
      }
    }
  }
}
```

## Backend Integration

The zirodelta backend calls:

```
POST https://clawdbot-railway-template-production-80832.up.railway.app/v1/chat/completions
Headers:
  Authorization: Bearer ${OPENCLAW_GATEWAY_TOKEN}
  x-openclaw-session-key: ziro:user:${user_id}
  x-openclaw-agent-id: main
  Content-Type: application/json
Body:
  { "model": "openclaw", "messages": [...], "stream": true }
```

## Environment Variables (Backend)

| Variable | Description |
|----------|-------------|
| `OPENCLAW_GATEWAY_URL` | `https://clawdbot-railway-template-production-80832.up.railway.app` |
| `OPENCLAW_GATEWAY_TOKEN` | Auth token from Railway Variables |

## Session Isolation

Each user gets a unique session key: `ziro:user:{user_id}`

This ensures:
- Separate conversation history
- Separate memory/context
- No data leakage between users

## Agent Capabilities

The Delta agent can:
- Answer questions about funding rate arbitrage
- Explain trading concepts
- Guide users through the platform
- (Future) Execute trades with user approval

## Local Development

```bash
# Install OpenClaw
npm install -g openclaw

# Run locally with config
openclaw gateway
```

Then configure via `http://localhost:18789/setup`
