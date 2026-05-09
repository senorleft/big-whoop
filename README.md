# Big Whoop

Big Whoop is a small public support site for a private local-first personal WHOOP data export project. The public repository exists to provide a privacy policy and OAuth redirect page required for WHOOP Developer app setup.

## Privacy Defaults

Never commit `.env`, OAuth tokens, SQLite databases, RustFS volumes, raw payloads, backups, logs, exports, or local implementation code unless you intentionally decide to make that code public. The default `.gitignore` keeps the local app implementation private and leaves only the public support files addable.

## Public Static Site

The `site/` directory is the public-facing surface intended for GitHub Pages. It contains:

- `site/index.html`: public project summary.
- `site/privacy/index.html`: privacy policy for the WHOOP Developer app listing.
- `site/oauth/callback/index.html`: static OAuth callback helper that displays the local `big-whoop auth exchange` command.

Publish only the static site to GitHub Pages:

```bash
scripts/publish-site.sh origin gh-pages
```

The script copies only `site/` into a temporary git repository and force-pushes that content to the `gh-pages` branch. It does not publish the local CLI code, token files, SQLite databases, RustFS data, logs, backups, or exports.

Use the resulting Pages URLs in the WHOOP Developer Dashboard:

- Privacy Policy URL: `https://<github-username>.github.io/<repo-name>/privacy/`
- Redirect URI: `https://<github-username>.github.io/<repo-name>/oauth/callback/`

## WHOOP OAuth Setup

Before authenticating locally, create a WHOOP Developer app at `https://developer.whoop.com/`.

Use these local settings:

- Redirect URI: the GitHub Pages callback URL, for example `https://<github-username>.github.io/<repo-name>/oauth/callback/`
- Scopes: `offline`, `read:profile`, `read:body_measurement`, `read:cycles`, `read:recovery`, `read:sleep`, `read:workout`

Use the published callback URL in the local app's private environment file. Do not commit that private file.

## Public Commit Check

Before committing, verify what will be included:

```bash
git add --dry-run .
```

By default, this should include only `.gitignore`, `.env.example`, `README.md`, `site/`, and `scripts/publish-site.sh`.
