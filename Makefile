.PHONY: up down logs smoke status clean

# Start Open WebUI
up:
	docker compose up -d
	@echo "Waiting for Open WebUI to start..."
	@sleep 5
	@echo "Open WebUI: http://localhost:3000"

# Stop Open WebUI
down:
	docker compose down

# View logs
logs:
	docker compose logs -f

# Run smoke test
smoke:
	@./scripts/smoke.sh

# Check container status
status:
	docker compose ps

# Clean up (removes volumes - will delete all data!)
clean:
	docker compose down -v
	@echo "Removed containers and volumes"
