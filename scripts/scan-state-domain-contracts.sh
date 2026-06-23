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

section "State and domain signals"
for path in \
  src/state \
  src/store \
  src/stores \
  src/redux \
  src/domain \
  src/domains \
  src/features \
  src/feature \
  app/store.ts \
  src/store.ts \
  src/state.ts; do
  if [ -e "$TARGET/$path" ]; then
    printf '%s\n' "$path"
  fi
done

section "Store, slice, and reducer files"
rg --files "$TARGET" 2>/dev/null |
  rg '(^|/)(store|state|slice|reducer|reducers|actions|selectors|events|machine|workflow)\.(ts|tsx|js|jsx)$|(^|/)(state|store|stores|redux|domain|domains)/' |
  limit_output || true

section "State contract type names"
run_rg '(type|interface)[[:space:]]+[A-Za-z0-9_]*(State|Store|Slice|Action|Event|Payload|Status|Phase|Mode|Machine)[A-Za-z0-9_]*'

section "State creators and selectors"
run_rg '(createSlice|createStore|configureStore|zustand|create\(|atom\(|selector\(|useReducer|useState|export[[:space:]]+const[[:space:]]+(select|use|add|remove|update|set|reset)[A-Za-z0-9_]+)'

section "Action and event literal leads"
run_rg '(type|kind|action|event|status|phase|mode)[[:space:]]*:[[:space:]]*["'\''][A-Za-z0-9_:/.-]+["'\'']|["'\''][A-Za-z0-9_-]+/(add|remove|update|set|reset|load|success|error|failed|done)["'\'']'

section "Status machine literal leads"
run_rg '["'\''](idle|loading|loaded|success|error|failed|pending|queued|done|draft|active|archived|approved|rejected|enabled|disabled)["'\'']'

section "Selector return leads"
run_rg 'export[[:space:]]+const[[:space:]]+select[A-Za-z0-9_]+[[:space:]]*=|function[[:space:]]+select[A-Za-z0-9_]+'

symbol_tmp="$(mktemp "${TMPDIR:-/tmp}/website-shower-state-symbols.XXXXXX")"
trap 'rm -f "$symbol_tmp"' EXIT

run_rg '(type|interface)[[:space:]]+[A-Za-z0-9_]*(State|Store|Slice|Action|Event|Payload|Status|Phase|Mode|Machine)[A-Za-z0-9_]*' > "$symbol_tmp"

section "Repeated state/domain type names"
awk -F: '
  {
    line = $0
    if (match($0, /(type|interface)[[:space:]]+[A-Za-z0-9_]+/)) {
      chunk = substr($0, RSTART, RLENGTH)
      split(chunk, parts, /[[:space:]]+/)
      name = parts[2]
      count[name] += 1
      if (count[name] <= 8) {
        locations[name] = locations[name] "\n  " line
      }
    }
  }
  END {
    found = 0
    for (name in count) {
      if (count[name] > 1) {
        found = 1
        printf "%s appears %d times:%s\n", name, count[name], locations[name]
      }
    }
    if (!found) {
      print "No repeated state/domain type names found."
    }
  }
' "$symbol_tmp" | limit_output

cat <<'NOTE'

== Notes ==
This script prints state and domain contract candidates only. Confirm the real state owner,
feature boundary, runtime event source, and selector consumers before reporting a task.
Repeated status values can be valid when separate lifecycles share the same words.
NOTE
