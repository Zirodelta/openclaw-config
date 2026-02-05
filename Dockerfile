# OpenClaw Gateway for Zirodelta
FROM node:22-slim

WORKDIR /app

# Install git (required for npm to install some packages)
RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Create OpenClaw config directory and copy config to default location
RUN mkdir -p /root/.openclaw
COPY config.json5 /root/.openclaw/config.json5

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Run OpenClaw Gateway (reads from ~/.openclaw/config.json5 by default)
CMD ["openclaw", "gateway", "--port", "8080", "--bind", "lan", "--allow-unconfigured"]
