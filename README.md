# Ollama + Open WebUI PoC

[![GitHub](https://img.shields.io/badge/GitHub-formicag%2Follama--openwebui--poc-181717?logo=github)](https://github.com/formicag/ollama-openwebui-poc)

Minimal production-ready setup to run [Open WebUI](https://github.com/open-webui/open-webui) connected to a local [Ollama](https://ollama.ai) instance on macOS.

## Prerequisites

- **Docker Desktop** running on macOS
- **Ollama** installed and running locally with at least one model

### Install Ollama (if not already installed)

```bash
brew install ollama
ollama serve  # Start Ollama server (runs on port 11434)
ollama pull llama3.1:8b  # Pull a model
```

## Quick Start

### Option 1: Desktop Launcher (Recommended)

Double-click **"Open WebUI.command"** on your Desktop.

This automatically:
- Starts Ollama (if not running)
- Starts Docker Desktop (if not running)
- Launches Open WebUI container
- Opens http://localhost:3000 in your browser

> **Note:** First time macOS may ask to allow the script. Right-click > Open > Open to allow.

To install the launcher (creates a symlink on Desktop):
```bash
ln -sf "$(pwd)/Open WebUI.command" ~/Desktop/"Open WebUI.command"
```

### Option 2: Command Line

```bash
make up      # Start Open WebUI
make smoke   # Verify everything is working
```

Then open http://localhost:3000 in your browser.

## First-Time Setup

1. Open http://localhost:3000
2. Create an admin account (first user becomes admin)
3. Go to Settings > Models
4. Your Ollama models should appear automatically

## Makefile Commands

| Command | Description |
|---------|-------------|
| `make up` | Start Open WebUI container |
| `make down` | Stop Open WebUI container |
| `make logs` | Follow container logs |
| `make smoke` | Run smoke test to verify setup |
| `make status` | Show container status |
| `make clean` | Remove containers and volumes (deletes all data!) |

## Architecture

```
┌─────────────────┐     ┌──────────────────────────┐
│     Browser     │────▶│   Open WebUI (Docker)    │
│  localhost:3000 │     │   Container port: 8080   │
└─────────────────┘     └────────────┬─────────────┘
                                     │
                        host.docker.internal:11434
                                     │
                                     ▼
                        ┌──────────────────────────┐
                        │    Ollama (Host macOS)   │
                        │    localhost:11434       │
                        └──────────────────────────┘
```

- Ollama runs natively on macOS (not in Docker)
- Open WebUI runs in Docker, connects to host Ollama via `host.docker.internal`
- Data persisted in Docker volume `open-webui-data`

## Troubleshooting

### Smoke test fails on Ollama check

```
Error: Ollama not reachable at http://localhost:11434
```

**Fix:** Ensure Ollama is running:
```bash
ollama serve
```

### Smoke test fails on Open WebUI check

```
Error: Open WebUI not reachable at http://localhost:3000
```

**Fix:** Check if container is running:
```bash
make status
make logs
```

### No models appear in Open WebUI

1. Verify Ollama has models: `ollama list`
2. Check Open WebUI can reach Ollama: Go to Settings > Connections
3. Ensure `OLLAMA_BASE_URL` is set to `http://host.docker.internal:11434`

### Port 3000 already in use

Edit `docker-compose.yml` and change the port mapping:
```yaml
ports:
  - "3001:8080"  # Use port 3001 instead
```

### Reset Open WebUI (fresh start)

```bash
make clean  # Warning: deletes all users, chats, settings
make up
```

## Security Notes

- Ollama is not exposed to the network (only accessible from Docker via `host.docker.internal`)
- Open WebUI is exposed on `localhost:3000` only (not externally accessible)
- First user to sign up becomes admin
- No secrets or credentials stored in repository
- Telemetry disabled by default

## License

MIT

## Author

[Gianluca Formica](https://github.com/formicag)
