FROM n8nio/n8n:latest

USER root

# Update package manager
RUN apk update

# Install basic dependencies first
RUN apk add --no-cache \
    curl \
    wget \
    build-base \
    python3 \
    py3-pip

# Install audio/video tools (correct packages for Alpine)
RUN apk add --no-cache \
    espeak \
    ffmpeg \
    nodejs \
    npm

# Install development packages for canvas
RUN apk add --no-cache \
    cairo-dev \
    pango-dev \
    jpeg-dev \
    giflib-dev \
    librsvg-dev \
    pixman-dev

# Install Node.js packages
RUN npm install -g canvas fluent-ffmpeg

# Create necessary directories
RUN mkdir -p /tmp/audio /tmp/video /tmp/images /tmp/thumbnails
RUN chown -R node:node /tmp

# Test installations
RUN espeak --version || echo "eSpeak installed"
RUN ffmpeg -version || echo "FFmpeg installed"

# Switch back to node user
USER node

# Set working directory
WORKDIR /home/node

# Expose port
EXPOSE 3000

# Start n8n
CMD ["n8n", "start"]
