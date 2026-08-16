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

Before running the project, ensure you have:
- Docker installed
- Docker Compose available
- a local terminal or shell environment

## Local Setup

From the project root, run:

```bash
docker compose -f docker-compose_local.yml up -d --build