# CMPS3162 Quiz #6

## YouTube Demo

{pending}

## Asynchronous Job Worker

| Key               | Value                                          |
| ----------------- | ---------------------------------------------- |
| **Student Name**  | [Andres Hung](https://github.com/andreshungbz) |
| **Student Email** | 2018118240@ub.edu.bz                           |
| **Course**        | CMPS3162 - Advanced Databases                  |
| **Due Date**      | April 28, 2026                                 |

## Running the Application

### Docker Compose

```
docker compose up
```

### Manual Method

#### Pre-requisites

- make
- curl
- golang-migrate

#### Database Setup

```
CREATE role async_user WITH LOGIN PASSWORD 'async_password';
CREATE DATABASE async_demo;
ALTER DATABASE async_demo OWNER TO async_user;
```

#### Application Setup

```
cp .envrc.example .envrc
make db/migrations/up
make run
```
