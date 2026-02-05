# OpenClaw Gateway for Zirodelta
FROM node:22-slim

WORKDIR /app

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Copy configuration
COPY config.yaml /app/config.yaml

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Run OpenClaw Gateway
CMD ["openclaw", "gateway", "--config", "/app/config.yaml"]
