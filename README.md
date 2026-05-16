# Pulse Ledger

Pulse Ledger is a small public support site for a private local-first personal WHOOP data export project. The public repository exists to provide the public website, privacy policy, and OAuth redirect page required for WHOOP Developer app setup.

## Privacy Defaults

Never commit `.env`, OAuth tokens, SQLite databases, RustFS volumes, raw payloads, backups, logs, exports, or local implementation code unless you intentionally decide to make that code public. The default `.gitignore` keeps the local app implementation private and leaves only the public support files addable.

## Public Static Site

The `site/` directory is the only public-facing surface intended for Cloudflare Pages. It contains:

- `site/index.html`: public project summary.
- `site/privacy/index.html`: privacy policy for the WHOOP Developer app listing.
- `site/oauth/callback/index.html`: static OAuth callback helper that displays the local `pulse-ledger auth exchange` command.

Deploy the site with Cloudflare Pages Git integration:

- Project name: `pulse-ledger`
- Repository: current GitHub repository connected through Cloudflare Pages
- Production branch: `master`
- Framework preset: none/static
- Root directory: repository root
- Build command: `exit 0`
- Build output directory: `site`

Cloudflare should upload only the contents of `site/`. It should not deploy the repository root, local CLI code, token files, SQLite databases, RustFS data, logs, backups, or exports.

Cloudflare assigned the project domain `pulse-ledger.pages.dev`. Use these URLs in the WHOOP Developer Dashboard:

- Website URL: `https://pulse-ledger.pages.dev/`
- Privacy Policy URL: `https://pulse-ledger.pages.dev/privacy/`
- Redirect URI: `https://pulse-ledger.pages.dev/oauth/callback/`

The `scripts/publish-site.sh` script remains available only as a GitHub Pages fallback:

```bash
scripts/publish-site.sh origin gh-pages
```

The fallback script copies only `site/` into a temporary git repository and force-pushes that content to the `gh-pages` branch.

## WHOOP OAuth Setup

Before authenticating locally, create a WHOOP Developer app at `https://developer.whoop.com/`.

Use these local settings:

- Redirect URI: `https://pulse-ledger.pages.dev/oauth/callback/`
- Scopes: `offline`, `read:profile`, `read:body_measurement`, `read:cycles`, `read:recovery`, `read:sleep`, `read:workout`

Use the published callback URL in the local app's private environment file. Do not commit that private file.

## Local Ingestion

Install the local package dependencies before syncing:

```bash
python3 -m pip install -e .
```

Start RustFS before the first sync. `RUSTFS_ACCESS_KEY` and `RUSTFS_SECRET_KEY` must be set in `.env`.

```bash
docker compose up -d rustfs
```

Useful local commands:

```bash
PYTHONPATH=src python3 -m pulse_ledger auth refresh
PYTHONPATH=src python3 -m pulse_ledger whoop profile
PYTHONPATH=src python3 -m pulse_ledger sync whoop --all-available
PYTHONPATH=src python3 -m pulse_ledger sync whoop --recent-days 14
PYTHONPATH=src python3 -m pulse_ledger sync whoop --from 2026-05-01 --to 2026-05-10
PYTHONPATH=src python3 -m pulse_ledger inspect db
PYTHONPATH=src python3 -m pulse_ledger inspect raw
```

Sync writes exact WHOOP v2 API JSON responses to RustFS and normalized records to SQLite. The database and raw payloads stay under `data/` and are intentionally ignored by git.

## Local Sleep Lab

Build or refresh the daily sleep rollups after syncing WHOOP data:

```bash
PYTHONPATH=src python3 -m pulse_ledger metrics sleep rebuild
PYTHONPATH=src python3 -m pulse_ledger metrics sleep status
```

Start the private localhost dashboard:

```bash
pulse-ledger start
```

Open `http://127.0.0.1:3000/`. `pulse-ledger start` checks whether today's WHOOP sync is current, refreshes recent data when needed, rebuilds daily sleep metrics, starts the local dashboard on `127.0.0.1`, and opens the browser. Stop the managed dashboard process with:

```bash
pulse-ledger stop
```

The dashboard reads only derived SQLite rollups and local status metadata. It does not read OAuth tokens, client secrets, RustFS credentials, or raw WHOOP payload JSON.

## Public Commit Check

Before committing, verify what will be included:

```bash
git add --dry-run .
```

By default, this should include only `.gitignore`, `.env.example`, `README.md`, `site/`, and `scripts/publish-site.sh`.
