# OpenCode Adapter

OpenCode reads `opencode.json` from the project root. That file points to `.opencode/instructions/types-constants-audit.md`, which is the OpenCode-specific adapter for the canonical skill.

Commands are intentionally not shipped yet. v0.1 has one primary workflow, so a command folder would add ceremony without improving use.

When phase two adds separate audit modes, add commands under:

```text
.opencode/command/
```

Likely future commands:

- `audit-types.md`
- `audit-tailwind.md`
- `audit-unused.md`
- `audit-next-habits.md`
