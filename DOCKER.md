# Docker setup – 420 CDMX / Vallarta

Run the app with **PHP 8.2 + Apache**, **MariaDB**, and **PHPMyAdmin** using Docker Compose.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)

## Quick start

1. **Copy the example env file** (optional; defaults work for local dev):

   ```bash
   cp .env.example .env
   ```

   Edit `.env` if you want different DB credentials or root password.

2. **Start the stack:**

   ```bash
   docker compose up -d
   ```

3. **Import the database** (first time only):

   - Open **PHPMyAdmin:** [http://localhost:8081](http://localhost:8081)
   - Log in with user `vallarta` / password `vallarta` (or your `DB_USER` / `DB_PASS` from `.env`), or use root / `rootpassword`.
   - Create/select the database `vallarta` (or your `DB_NAME`).
   - Import **`settings/db.sql`** or **`settings/vallart-db.sql`** (and **`database_updates_accounting.sql`** if you use the accounting/source features).

4. **Open the app:**

   - **App:** [http://localhost:8080](http://localhost:8080)
   - **PHPMyAdmin:** [http://localhost:8081](http://localhost:8081)

## Services

| Service     | Port  | Description                    |
|------------|-------|--------------------------------|
| **app**    | 8080  | PHP app (Apache)               |
| **db**     | 3306  | MariaDB 10.11                  |
| **phpmyadmin** | 8081 | PHPMyAdmin (DB UI)        |

## Environment variables

In `.env` (or set in `docker-compose.yml`):

| Variable               | Default     | Description                    |
|------------------------|------------|--------------------------------|
| `DB_HOST`              | `db`       | Database host (service name)   |
| `DB_USER`              | `vallarta` | DB user for the app           |
| `DB_PASS`              | `vallarta` | DB password                   |
| `DB_NAME`              | `vallarta` | Database name                 |
| `MYSQL_ROOT_PASSWORD`  | `rootpassword` | MariaDB root password     |

The app’s `settings/db.php` is generated at container start from these values (see `docker-entrypoint.sh`).

## Useful commands

```bash
# Start in background
docker compose up -d

# View logs
docker compose logs -f app

# Stop
docker compose down

# Stop and remove database volume (resets DB)
docker compose down -v
```

## Notes

- **Uploads:** The `uploads/` directory is stored in a Docker volume so files persist across container rebuilds.
- **Composer:** `composer install` runs during the image build; if it fails (e.g. network), the build may still succeed and you can run it manually inside the container.
- **Local `db.php`:** For non-Docker runs, keep using your own `settings/db.php`. The image ignores the repo’s `db.php` and generates it from env at startup.
