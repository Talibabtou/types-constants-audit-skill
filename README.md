# Types Constants Audit

`types-constants-audit` is a Codex skill for auditing TypeScript type and constant organization in web repos.

It helps answer one practical question: where should this type, literal union, enum-like object, or constant live?

## What It Reviews

- duplicated `Status`, `Role`, `Kind`, `Variant`, `Mode`, and `Type` concepts
- repeated literal unions
- magic strings and numbers that are shared across feature boundaries
- stale exports
- oversized `types.ts`, `constants.ts`, and enum-like files
- feature-owned values that were promoted too high
- fake reuse where an inline literal is clearer

## Current Scope

v0.1 is report-only. It produces findings and suggested moves; it does not refactor automatically unless the user explicitly asks for edits.

## Install For Codex

Clone the repo into your Codex skills directory:

```bash
git clone https://github.com/Talibabtou/types-constants-audit.git ~/.codex/skills/types-constants-audit
```

Then ask Codex to audit a TypeScript repo for type and constant placement.

## Use In Claude Or Cursor

Paste the contents of `SKILL.md` into the agent instructions. If the audit needs more judgment, also paste:

- `references/placement-rules.md`
- `references/report-format.md`

## Example Prompt

```text
Audit this repo for duplicated types, scattered constants, magic literals, stale exports, and bad global/local placement. Produce findings only; do not edit files.
```

## Status

See `ROADMAP.md` for the delivery checklist.
