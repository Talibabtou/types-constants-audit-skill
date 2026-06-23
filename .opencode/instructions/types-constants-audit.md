# Types Constants Audit For OpenCode

Use this repository as a read-only audit workflow for TypeScript type and constant organization.

Load these files as needed:

- `SKILL.md` for the canonical workflow.
- `references/audit-heuristics.md` for signal vs noise.
- `references/placement-rules.md` for inline/local/global/shared placement.
- `references/report-format.md` for output shape.

When shell access is available, run:

```bash
scripts/scan-types-constants.sh <target>
```

For monorepos, scan the root only for orientation, then scan one app/package/domain.

Do not edit the audited repo unless the user explicitly asks for fixes. Scanner output is candidate evidence only; confirm ownership, shape, and usage before reporting a finding.
