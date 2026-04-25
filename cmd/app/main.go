package main

import (
	"context"
	"database/sql"
	"flag"
	"log/slog"
	"os"
	"sync"
	"time"

	_ "github.com/lib/pq"
)

// config stores the configuration information.
type config struct {
	port int // API server port
	db   struct {
		dsn string // data source name
	}
}

// application holds the dependencies so that they are all accessible through dependency injection.
type application struct {
	config config
	logger *slog.Logger
	wg     sync.WaitGroup
}

func main() {
	var cfg config
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))

	// FLAGS

	flag.IntVar(&cfg.port, "port", 4001, "Application port")
	flag.StringVar(&cfg.db.dsn, "db-dsn", "", "PostgreSQL DSN")
	flag.Parse()

	// DATABASE

	db, err := openDB(cfg)
	if err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}
	defer db.Close()
	logger.Info("Database connection pool established")

	// APPLICATION

	app := &application{
		config: cfg,
		logger: logger,
	}

	err = app.serve()
	if err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}
}

// openDB connects to the PostgreSQL database using the provided DSN and
// and returns a pointer to a handler to that database.
func openDB(cfg config) (*sql.DB, error) {
	db, err := sql.Open("postgres", cfg.db.dsn)
	if err != nil {
		return nil, err
	}

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// test the connection with a ping
	err = db.PingContext(ctx)
	if err != nil {
		db.Close()
		return nil, err
	}

	return db, nil
}
