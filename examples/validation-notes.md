# Validation Notes

These notes record the v0.1.0 release-gate validation done against the anonymous fixture. Real-repo validation should be repeated after installing the skill in Codex.

## Target

- Target: `examples/fixture`
- Shape: small TypeScript app with `src/state`, `src/feature`, and `src/ui`
- Mode: read-only

## Command

```bash
MAX_SECTION_LINES=80 scripts/scan-types-constants.sh examples/fixture
```

## Outcome

- Findings/leads produced: 5
- Medium-confidence findings: 3
- Lower-confidence cleanup leads: 2
- Files modified in audited target: 0

## Findings Produced

1. `WorkItem` duplicated between state contract and feature slice.
2. `'queued' | 'done' | 'error'` duplicated as a runtime status union.
3. `DomainEvent` duplicated between owner contract and consumer.
4. `'left' | 'right'` repeated across state and feature boundaries, but ownership needs confirmation.
5. `ResourceMap` repeated in nearby feature data modules, but ownership needs confirmation.

## False Positives Ignored

- `AppState`: fixture includes both store-derived and hand-written shapes. In real repos, store-derived state often wins and needs inspection before reporting.
- `ProcessStep`: an owner union exists, but the raw literals appear in one nearby helper only. This is not enough for a finding.
- UI `default`: local UI variant, not a domain constant.
- Repeated primitive constants: none found.

## Misses Or Rule Changes Discovered

- No scanner changes required from this fixture validation.
- The example confirms the report should explicitly separate scanner leads from final findings.
- Real-repo validation is still needed after installing the skill in Codex to verify trigger behavior and adapter loading.

## Installed Codex Skill Validation

Validated after installing the skill in Codex and running it against a feature-oriented TypeScript website.

Outcome:

- Findings produced: 4
- Files modified in audited target: 0
- Overall result: useful, appropriately read-only, and not overly noisy

Findings produced:

1. Wrong owner constant used for a same-value database status.
2. Runtime arrays duplicated with hand-written type unions.
3. Raw role/status literals bypassing existing owner constants.
4. Small app-global `types.ts` ownership drawer importing feature constants.

False positives or caution points:

- Same literal value does not always mean same owner. A note status and a note-change-request status can both contain `"approved"` while belonging to different database enums.
- Next.js route paths like `src/app/[locale]/...` must be quoted in shell commands to avoid zsh globbing.

Rule changes from validation:

- Added heuristic for same literal value with different DB/table/lifecycle owner.
- Added shell-safety guidance for bracketed paths.
