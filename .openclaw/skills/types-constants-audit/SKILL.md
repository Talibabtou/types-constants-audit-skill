---
name: types-constants-audit
description: Read-only audit for TypeScript type files, constant files, literal unions, enum-like values, stale exports, and shared vs feature-local placement in web repositories.
---

# Types Constants Audit

Use this skill to audit TypeScript type and constant organization without modifying the target repository.

If the repository checkout includes the root skill files, read:

- `SKILL.md`
- `references/audit-heuristics.md`
- `references/placement-rules.md`
- `references/report-format.md`

When shell access is available, run:

```bash
scripts/scan-types-constants.sh <target>
```

For monorepos, scan the root only for orientation, then scan one app/package/domain.

Report findings only after confirming shape, ownership, and usage. Do not edit audited files unless the user explicitly asks for fixes.
