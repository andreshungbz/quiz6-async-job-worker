# Makefile
# Structure adapted from https://lets-go-further.alexedwards.net/ (2025)

# ==================================================================================== #
# ENVIRONMENT & VARIABLES
# ==================================================================================== #

include .envrc

ECHO_PREFIX = [make]

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

## help: Print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

## run: Run the cmp/app application
.PHONY: run
run:
	go run ./cmd/app \
		-db-dsn=${DB_DSN} \
		-port=${PORT}

## run/worker: Run the Python worker application
.PHONY: run/worker
run/worker:
	uv run --project worker python -m worker.main

# ==================================================================================== #
# DATABASE MIGRATIONS
# ==================================================================================== #

## db/psql: Connect to the hotel database using psql as hotel_user
.PHONY: db/psql
db/psql:
	@psql ${DB_DSN}

## db/migrations/new name=$1: Create a new database migration
.PHONY: db/migrations/new
db/migrations/new:
	@echo 'Creating migration files for ${name}...'
	migrate create -seq -ext=.sql -dir=./migrations ${name}

## db/migrations/up: Apply all up database migrations
.PHONY: db/migrations/up
db/migrations/up:
	@echo 'Running up migrations...'
	migrate -path ./migrations -database ${DB_DSN} up

## db/migrations/down: Apply all down database migrations
.PHONY: db/migrations/down
db/migrations/down:
	@echo 'Reverting all migrations...'
	migrate -path ./migrations -database ${DB_DSN} down

## db/migrations/goto version=$1: Go to the specified migration version
.PHONY: db/migrations/goto
db/migrations/goto:
	@echo 'Going to schema migration version ${version}...'
	migrate -path ./migrations -database ${DB_DSN} goto ${version}

## db/migrations/fix version=$1: Force the schema_migrations table version
.PHONY: db/migrations/fix
db/migrations/fix:
	@echo 'Forcing schema migrations version to ${version}...'
	migrate -path ./migrations -database ${DB_DSN} force ${version}

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## tidy: Tidy module dependencies and format all .go files
.PHONY: tidy
tidy:
	@echo '${ECHO_PREFIX} Tidying module dependencies...'
	go mod tidy
	@echo '${ECHO_PREFIX} Verifying and vendoring module dependencies...'
	go mod verify
# 	go mod vendor
	@echo '${ECHO_PREFIX} Formatting .go files...'
	go fmt ./...

## audit: Run quality control checks and tests
.PHONY: audit
audit:
	@echo '${ECHO_PREFIX} Checking module dependencies...'
	go mod tidy -diff
	go mod verify
	@echo '${ECHO_PREFIX} Vetting code...'
	go vet ./...
# 	go tool staticcheck ./...
	@echo '${ECHO_PREFIX} Running tests...'
	go test -race -vet=off ./...

# ==================================================================================== #
# BUILD
# ==================================================================================== #

## build/app: Build the cmd/app application
.PHONY: build/app
build/app:
	@echo '${ECHO_PREFIX} Building cmd/app...'
	go build -ldflags='-s' -o=./bin/app ./cmd/app
	GOOS=linux GOARCH=amd64 go build -ldflags='-s' -o=./bin/linux_amd64/app ./cmd/app

# ==================================================================================== #
# TESTS
# ==================================================================================== #

## test/db/generate: Run query for inserting sample jobs to the database
.PHONY: test/db/generate
test/db/generate:
	@echo 'Inserting sample jobs for stress testing...'
	@psql ${DB_DSN} -f queries/01_insert_sample_jobs.sql

## test/db/indexes: Run query for listing indexes
.PHONY: test/db/indexes
test/db/indexes:
	@echo '${ECHO_PREFIX} Running DB query to list indexes...'
	@psql ${DB_DSN} -f queries/02_list_indexes.sql

## test/db/btree: Run query for testing query execution with B-Tree indexes
.PHONY: test/db/btree
test/db/btree:
	@echo '${ECHO_PREFIX} Running DB EXPLAIN ANALYZE to test queries that use B-Tree Indexes...'
	@psql ${DB_DSN} -f queries/03_btree_index_test.sql

## test/db/gin: Run query for testing query execution with GIN indexes
.PHONY: test/db/gin
test/db/gin:
	@echo '${ECHO_PREFIX} Running DB EXPLAIN ANALYZE to test queries that use GIN Indexes...'
	@psql ${DB_DSN} -f queries/04_gin_index_test.sql
