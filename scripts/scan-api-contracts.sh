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

run_rg() {
  local pattern="$1"
  shift

  rg \
    --color never \
    --line-number \
    --glob '*.ts' \
    --glob '*.tsx' \
    --glob '*.js' \
    --glob '*.jsx' \
    --glob '!*.d.ts' \
    --glob '!**/*.d.ts' \
    --glob '!**/__generated__/**' \
    --glob '!**/generated/**' \
    "$@" \
    "$pattern" \
    "$TARGET" 2>/dev/null | limit_output || true
}

section "Target"
printf '%s\n' "$TARGET"

section "API signals"
for path in \
  package.json \
  src/app/api \
  app/api \
  pages/api \
  src/pages/api \
  src/server \
  src/lib/api \
  src/features; do
  if [ -e "$TARGET/$path" ]; then
    printf '%s\n' "$path"
  fi
done

section "Route handler files"
rg --files "$TARGET" \
  --glob '**/app/api/**/route.ts' \
  --glob '**/app/api/**/route.tsx' \
  --glob '**/pages/api/**/*.ts' \
  --glob '**/pages/api/**/*.tsx' \
  --glob '!**/node_modules/**' \
  --glob '!**/dist/**' \
  --glob '!**/build/**' 2>/dev/null | limit_output || true

section "Request body parsing"
run_rg '(\brequest\b|\breq\b)\.(json|formData)\(|await[[:space:]]+[A-Za-z0-9_]+\.json\('

section "JSON response boundaries"
run_rg '(Response|NextResponse)\.json\(|res\.json\('

section "API fetch clients"
run_rg 'fetch\([^)]*["'\''][^"'\'']*(/api|api/)'

section "Schema validation leads"
run_rg '(z\.object|z\.array|\.parse\(|\.safeParse\(|valibot|v\.object|yup\.object|superstruct|arktype)'

section "API contract type names"
run_rg '(type|interface)[[:space:]]+[A-Za-z0-9_]*(Request|Response|Payload|Dto|DTO|Params|Result)[A-Za-z0-9_]*'

section "Mock and fixture API shapes"
run_rg '(mock|fixture|sample|stub).*(Request|Response|Payload|Dto|DTO|Result)|/api/' \
  --glob '*mock*.*' \
  --glob '*fixture*.*' \
  --glob '*stub*.*' \
  --glob '*test*.*' \
  --glob '*spec*.*'

cat <<'NOTE'

== Notes ==
This script prints API contract candidates only. Confirm route framework, request validation,
client usage, schema ownership, and mock ownership before reporting a cleanup task.
NOTE
