# AWS DevOps Pipeline Labs

A local multi-service DevOps project built to demonstrate container orchestration, backend integration, database connectivity, monitoring, and observability using Docker, PostgreSQL, Express, Prometheus, and Grafana.

## Overview

This project simulates a small production-style application environment in a local setup. It brings together multiple services to demonstrate how a modern application is typically structured and observed in a real-world DevOps workflow.

The project includes:
- a frontend application
- a backend API built with Node.js and Express
- a PostgreSQL database
- a log parsing utility
- Prometheus metrics collection
- Grafana dashboards for monitoring and visibility

## Architecture

The application is designed as a multi-tier local stack:

- Frontend: serves the user-facing interface
- Backend: exposes API endpoints and service health metrics
- Database: stores structured application data
- Log Parser: scans log files for errors and operational events
- Prometheus: scrapes application and exporter metrics
- Grafana: visualizes the metrics collected by Prometheus

## Tech Stack

- Docker
- Docker Compose
- Node.js
- Express
- PostgreSQL
- Prometheus
- Grafana
- Bash

## Repository Structure

- Dockerfile - container for the log parser
- scripts/log-parser.sh - Bash-based log parsing script
- server.log - sample log input
- apps/backend - Express backend service
- apps/frontend - frontend application
- apps/database - database schema and initialization scripts
- monitoring/prometheus - Prometheus configuration
- docker-compose_local.yml - local development stack
- docker-compose.prod.yml - production-style compose file
- terraform - Infrastructure-related working files

## Prerequisites

You need:
- macOS and Docker Desktop
- Git, if you need to clone the repository
- A terminal (Terminal.app or the VS Code integrated terminal)

### Install Docker Desktop

1. Download Docker Desktop for Mac from [Docker's download page](https://www.docker.com/products/docker-desktop/). Choose the Apple silicon or Intel version that matches your Mac.
2. Open the downloaded installer and move Docker to Applications when prompted.
3. Open Docker Desktop from Applications. Accept the prompts and wait until Docker Desktop reports that it is running. This starts the Docker daemon, the background service that builds and runs containers.
4. In a terminal, check that Docker and the Compose plugin are available:

	```bash
	docker --version
	docker compose version
	docker info
	```

	The first two commands print version numbers. `docker info` should show server details. If it says it cannot connect to the Docker daemon, Docker Desktop is not ready yet.

You can start Docker Desktop from the terminal with `open -a Docker`, then wait for it to finish starting before running Docker commands. On macOS, use Docker Desktop to run the daemon; do not try to start `dockerd` directly.

## Run Locally

Open a terminal in the repository's root directory (the directory containing `docker-compose_local.yml`). If you have not cloned the project yet:

```bash
git clone <repository-url>
cd aws-devops-pipeline-labs
```

Build the images and start the local services in the background:

```bash
docker compose -f docker-compose_local.yml up -d --build
```

The first run may take a few minutes while Docker downloads base images and builds the frontend and backend. Check the status of all containers, including ones that have already exited:

```bash
docker compose -f docker-compose_local.yml ps -a
```

The frontend, backend, database, exporter, Prometheus, and Grafana should stay running. The `log-parser` is a one-shot job: it prints its report and exits successfully, so it is normal for that container to show `Exited (0)`.

To follow service logs while they start, run:

```bash
docker compose -f docker-compose_local.yml logs -f
```

Press `Ctrl+C` to stop following logs; this does not stop the services.

## Open the Services

Once the containers are running, open:

| Service | Address | What to expect |
| --- | --- | --- |
| Frontend dashboard | <http://localhost:8080> | Click **Refresh Status** to request log data from the backend. |
| Backend status API | <http://localhost:4001/api/status> | JSON showing backend and database health. |
| Backend logs API | <http://localhost:4001/api/logs> | JSON containing the sample database log events. |
| Backend metrics | <http://localhost:4001/metrics> | Prometheus-formatted backend metrics. |
| Prometheus | <http://localhost:9090> | Query metrics or open **Status > Targets** to check scrape targets. |
| Grafana | <http://localhost:3000> | Sign in with the local demo credentials below. |

Grafana's credentials in this local Compose file are username `admin` and password `admin`. They are for local demonstration only and should not be reused in a deployed environment.

## Smoke Tests

This repository does not currently define an automated test suite or an `npm test` command. Use these manual smoke tests to verify the main services after startup.

1. Check the status of all containers:

	```bash
	docker compose -f docker-compose_local.yml ps -a
	```

	Long-running services should be up. The `log-parser` should show `Exited (0)` because it finishes after printing its report.

2. Check the one-shot log parser's report. It should show the incident summary and error count:

	```bash
	docker compose -f docker-compose_local.yml logs log-parser
	```

3. Check that the API can query PostgreSQL. `/api/status` should include `"status":"healthy"`; `/api/logs` should contain the sample incidents:

	```bash
	curl http://localhost:4001/api/status
	curl http://localhost:4001/api/logs
	```

4. Confirm the backend metrics endpoint responds with metric names:

	```bash
	curl http://localhost:4001/metrics
	```

5. Open <http://localhost:8080> and click **Refresh Status**. The dashboard should show the log count and latest event timestamp.

6. Open <http://localhost:9090/targets>. The `backend` and `postgres` scrape targets should become **UP** after Prometheus's first scrape (up to 15 seconds).

7. Optionally check the initialized database directly:

	```bash
	docker compose -f docker-compose_local.yml exec db \
	  psql -U postgres -d appdb -c "SELECT count(*) FROM log_events;"
	```

## Stop and Clean Up

Stop and remove the containers and Compose network, keeping the database volume for the next run:

```bash
docker compose -f docker-compose_local.yml down
```

Start them again later with the `up` command above. To also permanently delete the database's saved data and start with a fresh database next time, use:

```bash
docker compose -f docker-compose_local.yml down -v
```

The `-v` option deletes the PostgreSQL data volume. Use it only when you intentionally want to erase that data.

## Troubleshooting

- **Cannot connect to the Docker daemon:** Open Docker Desktop (`open -a Docker`) and wait until it reports that it is running. Then retry `docker info`.
- **A port is already in use:** Stop the other process using that port, or change the host-side port in `docker-compose_local.yml`. The ports used here are `8080`, `4001`, `5432`, `9187`, `9090`, and `3000`.
- **The API is unavailable just after startup:** Check `docker compose -f docker-compose_local.yml logs backend db`. If the backend attempted to connect before PostgreSQL finished initializing, restart it with `docker compose -f docker-compose_local.yml restart backend` and retry the API smoke tests.
- **A service is not running:** Inspect its output with `docker compose -f docker-compose_local.yml logs <service-name>`, replacing `<service-name>` with the service name shown by `docker compose -f docker-compose_local.yml ps`.