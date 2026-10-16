#!/usr/bin/env bash
# Mirror the Vercel docs pages listed in docs/vercel-official/sources.txt.
# Each page's markdown (<url>.md) is saved to docs/vercel-official/pages/<path>.md;
# the docs root saves as index.md. A failed fetch leaves the existing copy intact.
set -euo pipefail

root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
sources="$root/docs/vercel-official/sources.txt"
pages="$root/docs/vercel-official/pages"
prefix="https://vercel.com/docs"

tmp="$(mktemp -d "${TMPDIR:-/tmp}/vercel-docs.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT

ok=0
failed=0

while IFS= read -r url || [[ -n "$url" ]]; do
  url="${url%%#*}"
  url="${url//[[:space:]]/}"
  [[ -z "$url" ]] && continue
  url="${url%/}"
  url="${url%.md}"

  # Only official docs paths; reject anything that could escape pages/.
  if [[ "$url" != "$prefix" && "$url" != "$prefix/"* ]] || [[ "$url" == *..* ]]; then
    echo "SKIP  $url (not under $prefix)" >&2
    failed=$((failed + 1))
    continue
  fi

  path="${url#"$prefix"}"
  path="${path#/}"
  dest="$pages/${path:-index}.md"
  part="$tmp/page.md"

  if ! type="$(curl -fsSL --proto '=https' --max-time 30 -o "$part" \
    -w '%{content_type}' "$url.md")"; then
    echo "FAIL  $url (fetch error)" >&2
    failed=$((failed + 1))
    continue
  fi

  # Most pages carry frontmatter but some (the sitemap) do not, so trust the
  # content type; anything else is likely an HTML page.
  if [[ "$type" != text/markdown* ]]; then
    echo "FAIL  $url (content type ${type:-none}; not markdown)" >&2
    failed=$((failed + 1))
    continue
  fi

  mkdir -p "$(dirname "$dest")"
  mv "$part" "$dest"
  echo "OK    $url -> ${dest#"$root/"}"
  ok=$((ok + 1))
done < "$sources"

echo "Synced $ok page(s), $failed failure(s)."
[[ "$failed" -eq 0 ]]
