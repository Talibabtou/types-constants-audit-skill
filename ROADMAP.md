# Types Constants Audit Skill Delivery Checklist

Goal: deliver `types-constants-audit`, a small agent skill that reviews, organizes, and prunes TypeScript type and constant files in web repos.

The skill should answer one hard question well: where should this type, literal union, enum-like object, or constant live?

## Product Definition

- [x] Name the skill `types-constants-audit`.
- [x] Define the primary users:
  - Codex users running repo audits
  - Claude/Cursor users pasting skill instructions manually
  - maintainers cleaning messy `types.ts`, `constants.ts`, enum-ish files, and repeated literals
- [x] Set the v1 non-goal: no automatic refactors; first version reports findings and suggested moves.
- [x] Keep the core rules explicit:
  - global only after two unrelated features need it
  - feature-local when one product area owns it
  - inline when used once, fake-reused, or clearer as a literal
  - delete stale exports before moving them
  - prefer boring TypeScript primitives over clever type machinery unless repo already uses the pattern

## Phase 0: Repo Base

- [x] Create the minimum repo shape:

```text
SKILL.md
references/
  placement-rules.md
  report-format.md
```

- [x] Create `SKILL.md`.
- [x] Create `references/placement-rules.md`.
- [x] Create `references/report-format.md`.
- [x] Add `agents/openai.yaml` after the first `SKILL.md` pass.
- [x] Skip scripts for v0.1.
- [ ] Validate the skill with the Codex skill validator when available.
- [ ] Decide which root docs are for GitHub only and which files belong in the packaged skill.
- [ ] Confirm the packaged skill contains no extra docs beyond files needed by the agent.
- [ ] Confirm the root repo has only public-facing files needed for GitHub.

## Phase 1: Manual Audit Skill

- [x] Add trigger wording for:
  - type audits
  - constant audits
  - duplicated unions
  - magic literals
  - junk-drawer files
  - stale exports
- [x] Add a short audit workflow.
- [x] Add `rg` commands to inspect a repo.
- [x] Require reading local architecture before recommending moves.
- [x] Instruct the agent to produce findings, not broad refactor essays.
- [x] Write placement rules for local vs shared vs global vs inline decisions.
- [x] Write compact report format with severity and confidence labels.
- [ ] Run the skill manually on one real repo.
- [ ] Revise `SKILL.md` and references from the first real audit report.
- [ ] Confirm the skill can produce 5-15 useful findings without editing files.

## Phase 2: Test On Real Repos

- [ ] Run against a small Next.js app.
- [ ] Run against a feature-heavy React app.
- [ ] Run against a monorepo package.
- [ ] Run against a messy older repo with global `types.ts`.
- [ ] Record false positives that change skill behavior.
- [ ] Record missed duplicate status, role, kind, variant, mode, or type unions.
- [ ] Record bad move recommendations.
- [ ] Record cases where extracting constants made code worse.
- [ ] Update placement rules only from repeated evidence, not theory.
- [ ] Stop changing placement rules after two different repos produce no new rule changes.

## Phase 3: Tiny Script

Only do this if manual `rg` commands become repetitive.

- [x] Decide whether a script is justified by repeated manual audits.
- [x] If justified, add `scripts/scan-types-constants.sh`.
- [x] Keep the script limited to printing candidates; it must not decide architecture.
- [x] Scan candidate files:
  - `type .*=` and `interface `
  - `as const`
  - `const [A-Z0-9_]+`
  - status, role, variant, kind, mode, and type-like string literals
  - large `types.ts` and `constants.ts` files
- [ ] Add one sample fixture check if the script exists.
- [x] Replace the v0.1 script-free assumption with a tiny dependency-free scanner.

## Phase 4: Optional AST Pass

Only do this after shell scans hit real limits.

- [ ] Identify a real repo case that `rg` cannot handle cleanly.
- [ ] Decide whether TypeScript AST tooling would materially improve the audit.
- [ ] If justified, use AST tooling for:
  - export usage
  - duplicate type shape detection
  - literal union extraction
  - enum-like object detection
- [ ] Avoid adding dependencies until there is a failing real repo case.

## Phase 5: Public Release

- [x] Add root-level `README.md`.
- [ ] Add root-level `LICENSE`.
- [ ] Add `examples/` with one small before/after audit report.
- [ ] Keep the packaged skill lean.
- [x] Document install paths for Codex, Claude, and Cursor users.
- [ ] Ensure the example report shows judgment, not just search output.
- [ ] Create a versioned release tag.

## Repo Habits

- [ ] Keep files few.
- [ ] Ensure every file helps either the agent run the audit or a human install the skill.
- [ ] Use real repo examples where possible, anonymized when needed.
- [ ] Avoid baking in one framework's folder layout.
- [ ] Support Next.js, Vite, Remix, package folders, and monorepos as different ownership shapes.
- [ ] Use terms consistently:
  - `global`: app-wide shared primitive
  - `feature-local`: owned by one product area
  - `shared package`: cross-app or cross-package API
  - `inline`: literal kept at call site
  - `junk drawer`: file with unrelated exports
- [ ] Make every fallible heuristic explain how to override it.

## Quality Bar

Each good finding must name:

- [ ] current symbol
- [ ] current files
- [ ] recommended location
- [ ] reason
- [ ] confidence
- [ ] exact next action

The skill must:

- [ ] Catch duplicated `Status`, `Role`, `Kind`, `Variant`, `Mode`, and `Type` concepts.
- [ ] Catch constants used once.
- [ ] Catch stale exports.
- [ ] Avoid moving feature-owned types into `src/types.ts`.
- [ ] Flag giant mixed files without demanding a rewrite.
- [ ] Respect repo naming style.
- [ ] Avoid saying "centralize this" without proving unrelated reuse.

## First Working Milestone: v0.1

Expected v0.1 files:

```text
SKILL.md
references/
  placement-rules.md
  report-format.md
```

Current local state also includes:

```text
agents/
  openai.yaml
```

Before calling v0.1 done:

- [ ] Run the Codex skill validator when available.
- [ ] Run the skill manually on one repo.
- [ ] Revise from that report.
- [x] Confirm a tiny script is useful for candidate discovery.
- [ ] Decide whether `agents/openai.yaml` stays in v0.1 or moves to a later release.
