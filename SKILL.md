---
name: types-constants-audit
description: Audit website repos for file-tree drift, TypeScript type and constant drift, unused-code leads, TypeScript escape hatches, React/Next.js habit drift, Tailwind cleanup, API contract hygiene, state/domain contract hygiene, stale exports, and cleanup tasks. Use when asked for Website Shower, website maintenance audit, cleanup checklist, file-tree hygiene, duplicated types/constants, magic values, unused code, TypeScript hygiene, React/Next habits, Tailwind cleanup, API contracts, state contracts, domain contracts, or read-only repo cleanup.
---

# Website Shower

Audit website maintenance issues from repo evidence. Default mode is read-only: produce findings and recommendations, but do not edit files unless the user explicitly asks for fixes.

Website Shower coordinates multiple read-only website maintenance audits into a Markdown TODO report. Current modules cover file-tree hygiene, TypeScript hygiene, React/Next.js habits, Tailwind cleanup, API contracts, state/domain contracts, types/constants ownership, and unused-code leads.

## Workflow

1. Read repo shape first: framework, package manager, app/package layout, feature/domain folders, API boundaries, generated folders, and existing checker setup.
2. Run the global scanner when available:

```bash
scripts/scan-website-shower.sh .
```

For monorepos, treat a root scan as orientation only, then rerun against one owned app or package:

```bash
scripts/scan-website-shower.sh apps/example-app
scripts/scan-website-shower.sh packages/example-domain
```

3. Read scanner output in this order:
   - File-tree hygiene: app layout, packages, feature folders, generated folders, junk drawers, route shape.
   - TypeScript hygiene: checker setup, `any`, unsafe casts, JS migration leftovers, formatting and lint guardrails.
   - React/Next.js habits: app shape, server/client boundaries, metadata, route literals, fetch policy.
   - Tailwind cleanup: Tailwind presence, source coverage, dynamic classes, arbitrary values, duplicate utilities, CSS transition leads.
   - API contracts: routes, clients, schemas, mocks, request parsing, response shapes.
   - State/domain contracts: store state, selectors, event payloads, status machines, action names.
   - Types/constants ownership: repeated contracts, literal unions, raw domain values, barrels, junk drawers.
   - Unused code: stale exports and deletion leads after framework and public API context is known.
4. If the global scanner is unavailable, run focused scanners manually:

```bash
scripts/scan-file-tree-hygiene.sh .
scripts/scan-typescript-hygiene.sh .
scripts/scan-react-next-habits.sh .
scripts/scan-tailwind-cleanup.sh .
scripts/scan-api-contracts.sh .
scripts/scan-state-domain-contracts.sh .
scripts/scan-types-constants.sh .
scripts/scan-unused-code.sh .
```

If scripts are unavailable, use `rg` manually and let repo ignore files apply first. If the repo has no ignore files, add fallback exclusions:

```bash
--glob '!node_modules/**' --glob '!.git/**' --glob '!.next/**' --glob '!.turbo/**' --glob '!.vercel/**' --glob '!dist/**' --glob '!build/**' --glob '!coverage/**'
```

5. Inspect usage before recommending movement or deletion:

```bash
rg "\\bSymbolName\\b" .
rg "from ['\"].*(types|constants|enums)" .
```

Quote paths with shell-special characters when inspecting files directly, especially Next.js routes such as `'src/app/[locale]/profile/page.tsx'`.

6. Classify each task:
   - unclear file-tree boundary
   - missing checker guardrail
   - unsafe TypeScript escape hatch
   - framework boundary drift
   - styling token or utility drift
   - duplicated API contract
   - duplicated state or domain contract
   - duplicated type shape
   - duplicated literal union
   - repeated magic string or number
   - junk-drawer file
   - stale export
   - fake reuse that should stay inline
   - constant that hurts readability
   - drifted local contract that should use an existing owner
7. Apply the relevant reference before reporting:
   - `references/audit-orchestrator.md`
   - `references/file-tree-hygiene.md`
   - `references/typescript-hygiene.md`
   - `references/react-next-habits.md`
   - `references/tailwind-cleanup.md`
   - `references/api-contracts.md`
   - `references/state-domain-contracts.md`
   - `references/placement-rules.md`
   - `references/audit-heuristics.md`
   - `references/unused-code.md`
8. Format the final checklist with `references/report-format.md`.

## Core Judgment

- Global only after two unrelated features need it.
- Feature-local when one product area owns it.
- Inline when used once, fake-reused, or clearer as a literal.
- Delete stale exports before moving code.
- Repeated names, literals, and primitive values are leads, not findings. Confirm shape, ownership, and usage.
- Raw literals are strongest when the repo already has an owning constant or union and nearby code drifts from it.
- Same literal value can still need separate constants when ownership differs, for example two database enums that both include `"approved"` but belong to different tables or lifecycles.

## What To Report

Prioritize findings that reduce confusion:
- same concept named differently in unrelated files
- same literal union repeated across features
- shared `types.ts` or `constants.ts` exporting unrelated things
- constants imported far from their owner
- exported symbols with no runtime or type usage
- values promoted to global before real shared ownership exists
- store-derived types duplicated by hand-written aliases or interfaces
- event payload contracts duplicated between hooks, slices, and services
- repeated status/team/result unions that cross Redux, hooks, and UI
- `any`, double casts, or suppression comments near repo-owned boundaries
- JavaScript migration leftovers in typed source folders
- React/Next server-client boundary drift, route literal drift, and repeated fetch policy
- Tailwind source/config drift, dynamic class construction, repeated arbitrary values, and duplicate utilities
- API request/response contracts duplicated across routes, clients, schemas, mocks, and tests
- Store state, event payloads, selector return types, status machines, or action names duplicated across owners

Skip low-value noise:
- one-off JSX labels, route segments, HTTP method strings, and framework syntax
- test fixture strings and generated API/IDL/protobuf/GraphQL contract outputs
- CSS utility classes and local UI variant strings
- repeated `Props`/`State` names that are file-local
- repeated primitive values with different semantic owners

## Report Style

Lead with findings. Keep summary short.

Each finding must include:
- symbol or literal
- current file(s)
- recommended action
- reason
- confidence

A finding without concrete file paths is not release-quality. Use exact file paths and line numbers when available. If evidence is missing, mark it as a lead and say what path or usage check is still needed.

When unsure, say what evidence is missing instead of guessing. If there are no material findings, say so and mention search limits.

## Edit Mode

If the user asks for edits:
- make the smallest safe move
- update imports
- delete stale exports
- run the repo's typecheck or smallest relevant check
- avoid broad folder rewrites

Do not introduce a new shared file if an existing local owner is clearer.

## Skill Test Fixture

Use `examples/fixture` for scanner smoke testing only. It intentionally uses anonymous names so agents are not biased by product vocabulary.

```bash
tests/smoke-test.sh
```
