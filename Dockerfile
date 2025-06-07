FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    espeak espeak-data \
    ffmpeg \
    nodejs npm \
    curl wget

# Install n8n
RUN npm install -g n8n

EXPOSE 3000
CMD ["n8n", "start"]
