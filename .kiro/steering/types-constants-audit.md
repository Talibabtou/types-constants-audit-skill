# Types Constants Audit

Use this steering rule when auditing TypeScript type files, constant files, literal unions, enum-like values, magic strings/numbers, stale exports, or shared vs feature-local placement.

Default behavior is read-only. Produce findings and recommendations; do not edit audited repos unless explicitly asked.

Workflow:

1. Read `SKILL.md` if available.
2. Run `scripts/scan-types-constants.sh <target>` if shell access is available.
3. For monorepos, scan the root only for orientation, then scan one app/package/domain.
4. Apply `references/placement-rules.md` for placement decisions.
5. Apply `references/audit-heuristics.md` to separate signal from noise.
6. Format findings using `references/report-format.md`.

Treat repeated names, literals, and primitive values as leads, not findings. Confirm shape, ownership, and usage before recommending movement.
