FROM n8nio/n8n:latest

USER root

# Update package manager
RUN apk update && apk upgrade

# Install system dependencies
RUN apk add --no-cache \
    espeak \
    espeak-data \
    ffmpeg \
    python3 \
    py3-pip \
    build-base \
    cairo-dev \
    pango-dev \
    jpeg-dev \
    giflib-dev \
    librsvg-dev \
    nodejs \
    npm \
    curl \
    wget

# Install Node.js packages for video/audio processing
RUN npm install -g \
    canvas \
    fluent-ffmpeg \
    sharp

# Create necessary directories
RUN mkdir -p /tmp/audio /tmp/video /tmp/images /tmp/thumbnails
RUN chown -R node:node /tmp

# Test eSpeak installation
RUN espeak --version

# Test FFmpeg installation  
RUN ffmpeg -version

USER node

# Set working directory
WORKDIR /home/node

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/healthz || exit 1

# Start n8n
CMD ["n8n", "start"]
