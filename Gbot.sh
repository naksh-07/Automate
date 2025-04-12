#!/bin/bash

# Thoda swag ke sath start
echo "🚀 Starting chatbot container setup..."

# Step 1: Docker image pull
echo "📦 Pulling Docker image..."
docker pull rohan014233/chatbot-service:latest

# Step 2: Run the container
echo "🐳 Running Docker container..."
docker run -d \
  --name chatbot-container \
  -v "$(pwd)/Gbot.env:/run/secrets/Gbot.env:ro" \
  rohan014233/chatbot-service:latest

# Final status
if [ $? -eq 0 ]; then
  echo "✅ Chatbot container is up and running!"
else
  echo "❌ Something went wrong, bhai. Check Docker logs!"
fi
