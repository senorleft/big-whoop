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

## Public Commit Check

Before committing, verify what will be included:

```bash
git add --dry-run .
```

By default, this should include only `.gitignore`, `.env.example`, `README.md`, `site/`, and `scripts/publish-site.sh`.
