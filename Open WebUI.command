#!/bin/bash
# Open WebUI Launcher
# Double-click to start Ollama + Open WebUI and open browser

# Change to the directory where this script is located
cd "$(dirname "$0")"

echo "=== Open WebUI Launcher ==="
echo ""

# Check if Ollama is running, start if not
if ! curl -sf http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "Starting Ollama..."
    open -a Ollama
    sleep 3
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Starting Docker Desktop..."
    open -a Docker
    echo "Waiting for Docker to start (this may take a moment)..."
    while ! docker info > /dev/null 2>&1; do
        sleep 2
    done
    echo "Docker is ready."
fi

# Start Open WebUI container
echo "Starting Open WebUI..."
docker compose up -d

# Wait for Open WebUI to be ready
echo "Waiting for Open WebUI to be ready..."
for i in {1..30}; do
    if curl -sf http://localhost:3000 > /dev/null 2>&1; then
        break
    fi
    sleep 1
done

# Open browser
echo "Opening browser..."
open http://localhost:3000

echo ""
echo "=== Open WebUI is ready ==="
echo "Press any key to close this window..."
read -n 1
