#!/usr/bin/env bash

set -uo pipefail

TARGET="${1:-.}"
MAX_SECTION_LINES="${MAX_SECTION_LINES:-300}"

if [ ! -d "$TARGET" ]; then
  echo "error: target is not a directory: $TARGET" >&2
  exit 1
fi

section() {
  printf '\n== %s ==\n' "$1"
}

limit_output() {
  awk -v max="$MAX_SECTION_LINES" '
    NR <= max { print }
    NR == max + 1 {
      printf "... truncated after %d lines; narrow the target path for more detail.\n", max
      exit
    }
  '
}

print_if_exists() {
  local path
  for path in "$@"; do
    if [ -e "$TARGET/$path" ]; then
      printf '%s\n' "$path"
    fi
  done
}

section "Target"
printf '%s\n' "$TARGET"

section "Root signals"
print_if_exists \
  package.json \
  pnpm-workspace.yaml \
  turbo.json \
  nx.json \
  vite.config.ts \
  vite.config.js \
  next.config.js \
  next.config.mjs \
  tsconfig.json \
  jsconfig.json \
  biome.json \
  eslint.config.js \
  prettier.config.js

section "Top-level directories"
find "$TARGET" -mindepth 1 -maxdepth 1 -type d 2>/dev/null |
  sed "s#^$TARGET/##" |
  sort |
  limit_output

section "App and package layout"
print_if_exists \
  app \
  pages \
  src \
  src/app \
  src/pages \
  src/routes \
  apps \
  packages \
  services \
  workers \
  functions

section "Feature boundary leads"
print_if_exists \
  src/feature \
  src/features \
  src/modules \
  src/domains \
  src/components \
  src/ui \
  src/lib \
  src/utils \
  src/shared \
  src/state \
  src/stores \
  src/workers

if [ -d "$TARGET/src/feature" ] && [ -d "$TARGET/src/features" ]; then
  printf 'mixed feature folders: src/feature and src/features both exist\n'
fi

if [ -d "$TARGET/src/components" ] && [ -d "$TARGET/src/ui" ]; then
  printf 'mixed UI folders: src/components and src/ui both exist\n'
fi

section "Junk drawer file leads"
rg --files "$TARGET" 2>/dev/null |
  rg '(^|/)(types|constants|helpers|utils|misc|common|shared|index)\.(ts|tsx|js|jsx)$|(^|/)(lib|utils|helpers|common|shared)/[^/]+\.(ts|tsx|js|jsx)$' |
  limit_output || true

section "Generated and build boundary leads"
find "$TARGET" \
  \( -name node_modules -o -name .git \) -prune -o \
  -type d \
  \( -name generated -o -name __generated__ -o -name dist -o -name build -o -name .next -o -name coverage -o -name gen \) \
  -print 2>/dev/null |
  sed "s#^$TARGET/##" |
  sort |
  limit_output

section "Route layout leads"
rg --files "$TARGET" 2>/dev/null |
  rg '(^|/)app/.*/(page|layout|route)\.(ts|tsx|js|jsx)$|(^|/)pages/.*\.(ts|tsx|js|jsx)$|(^|/)api/.*\.(ts|tsx|js|jsx)$' |
  limit_output || true

section "Deep source files"
rg --files "$TARGET" --glob '*.{ts,tsx,js,jsx}' 2>/dev/null |
  awk -F/ 'NF >= 8 { print }' |
  limit_output

cat <<'NOTE'

== Notes ==
This script prints file-tree candidates only. Confirm repo conventions before reporting.
Mixed folders are often migration leftovers, not proof that a file should move.
Generated, build, and framework-owned folders should usually be ignored by later audits.
NOTE
