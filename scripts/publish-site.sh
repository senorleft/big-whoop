#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
site_dir="$repo_root/site"
remote_name="${1:-origin}"
branch_name="${2:-gh-pages}"

if [[ ! -d "$site_dir" ]]; then
  echo "site directory not found: $site_dir" >&2
  exit 1
fi

if ! git -C "$repo_root" remote get-url "$remote_name" >/dev/null 2>&1; then
  echo "git remote '$remote_name' is not configured." >&2
  echo "Add a GitHub remote first, then rerun: scripts/publish-site.sh $remote_name $branch_name" >&2
  exit 1
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

cp -R "$site_dir"/. "$tmp_dir"/

git -C "$tmp_dir" init
git -C "$tmp_dir" checkout -b "$branch_name"
git -C "$tmp_dir" config user.name "$(git -C "$repo_root" config user.name || echo "Pulse Ledger Publisher")"
git -C "$tmp_dir" config user.email "$(git -C "$repo_root" config user.email || echo "pulse-ledger@example.invalid")"
git -C "$tmp_dir" add .
git -C "$tmp_dir" commit -m "Publish static site"
git -C "$tmp_dir" remote add "$remote_name" "$(git -C "$repo_root" remote get-url "$remote_name")"

echo "About to force-push only the contents of $site_dir to $remote_name/$branch_name."
echo "No application code, local data, tokens, or repo history will be included."
git -C "$tmp_dir" push --force "$remote_name" "$branch_name"
