FROM ubuntu:20.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

# Update system
RUN apt-get update && apt-get upgrade -y

# Install Node.js 18
RUN apt-get install -y curl
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Install system dependencies
RUN apt-get install -y \
    espeak \
    espeak-data \
    ffmpeg \
    wget \
    build-essential \
    python3 \
    python3-pip \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev

# Install n8n and Node.js packages
RUN npm install -g n8n canvas fluent-ffmpeg

# Create user and directories
RUN useradd -ms /bin/bash n8n
RUN mkdir -p /tmp/audio /tmp/video /tmp/images
RUN chown -R n8n:n8n /tmp

# Test installations
RUN espeak --version
RUN ffmpeg -version
RUN node --version
RUN n8n --version

# Switch to n8n user
USER n8n
WORKDIR /home/n8n

# Environment variables
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=3000
ENV N8N_PROTOCOL=http

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/healthz || exit 1

# Start n8n
CMD ["n8n", "start"]
