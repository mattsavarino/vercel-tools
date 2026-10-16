#!/usr/bin/env bash
# Mirror the Vercel docs pages listed in docs/vercel-official/sources.txt.
# Each page's markdown (<url>.md) is saved to docs/vercel-official/pages/<path>.md;
# the docs root saves as index.md. A failed fetch leaves the existing copy intact.
# Ends with a git-based change report, so a periodic run shows what Vercel changed.
set -euo pipefail

root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
sources="$root/docs/vercel-official/sources.txt"
pages="$root/docs/vercel-official/pages"
prefix="https://vercel.com/docs"

tmp="$(mktemp -d "${TMPDIR:-/tmp}/vercel-docs.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT

ok=0
failed=0
expected="$tmp/expected.txt"
: > "$expected"

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
  echo "${dest#"$root/"}" >> "$expected"

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
  ok=$((ok + 1))
done < "$sources"

echo "Synced $ok page(s), $failed failure(s)."

# Change report against the last commit.
rel="${pages#"$root/"}"
status="$(git -C "$root" status --porcelain --untracked-files=all -- "$rel")"
added="$(grep -c '^??' <<< "$status" || true)"
changed="$(grep -c '^ M' <<< "$status" || true)"
echo "Changes since last commit: $added new, $changed changed."
[[ -n "$status" ]] && sed 's/^?? /NEW   /; s/^ M /DIFF  /' <<< "$status"

# Pages on disk that sources.txt no longer lists (dropped from the list, or a
# path Vercel moved). Reported, never deleted.
orphans="$(cd "$root" && find "$rel" -name '*.md' | sort | comm -23 - <(sort -u "$expected"))"
[[ -n "$orphans" ]] && sed 's/^/STALE /' <<< "$orphans"

[[ "$failed" -eq 0 ]]
