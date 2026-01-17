#!/usr/bin/env bash
# Smoke test for Ollama + Open WebUI setup
# Returns 0 if both services are reachable, non-zero otherwise

set -euo pipefail

OLLAMA_URL="${OLLAMA_URL:-http://localhost:11434}"
WEBUI_URL="${WEBUI_URL:-http://localhost:3000}"
TIMEOUT=5

echo "=== Smoke Test ==="

# Test 1: Ollama API reachable
echo -n "Checking Ollama at ${OLLAMA_URL}... "
if curl -sf --max-time "$TIMEOUT" "${OLLAMA_URL}/api/tags" > /dev/null 2>&1; then
    echo "OK"
else
    echo "FAIL"
    echo "Error: Ollama not reachable at ${OLLAMA_URL}"
    echo "Ensure Ollama is running: ollama serve"
    exit 1
fi

# Test 2: Ollama has at least one model
echo -n "Checking Ollama has models... "
MODEL_COUNT=$(curl -sf --max-time "$TIMEOUT" "${OLLAMA_URL}/api/tags" | grep -c '"name"' || echo "0")
if [ "$MODEL_COUNT" -gt 0 ]; then
    echo "OK (${MODEL_COUNT} model(s) found)"
else
    echo "FAIL"
    echo "Error: No models found in Ollama"
    echo "Pull a model: ollama pull llama3.1:8b"
    exit 1
fi

# Test 3: Open WebUI reachable
echo -n "Checking Open WebUI at ${WEBUI_URL}... "
if curl -sf --max-time "$TIMEOUT" "${WEBUI_URL}" > /dev/null 2>&1; then
    echo "OK"
else
    echo "FAIL"
    echo "Error: Open WebUI not reachable at ${WEBUI_URL}"
    echo "Ensure containers are running: make up"
    exit 1
fi

echo ""
echo "=== All checks passed ==="
echo "Open WebUI: ${WEBUI_URL}"
exit 0
