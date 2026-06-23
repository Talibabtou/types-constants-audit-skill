# Agent Portability

`types-constants-audit` is an instruction-first skill distribution. The canonical behavior lives in `SKILL.md`; host-specific files are thin adapters that make the same behavior easy to load in different agents.

## Supported Adapters

| Host | Files | Notes |
| --- | --- | --- |
| Codex skill | `SKILL.md`, `agents/openai.yaml`, `references/`, `scripts/` | Full skill behavior with scanner and progressive references. |
| Codex / OpenCode / CodeWhale style agents | `AGENTS.md` | Root project instructions. |
| OpenCode | `opencode.json`, `.opencode/instructions/types-constants-audit.md` | Root config loads the OpenCode-specific instruction adapter. Commands are deferred until there are multiple workflows. |
| OpenClaw | `.openclaw/skills/types-constants-audit/SKILL.md` | Install the directory as an OpenClaw skill package. The root `SKILL.md` remains canonical for this repo. |
| GitHub Copilot | `.github/copilot-instructions.md` | Repository instruction file. |
| Cursor | `.cursor/rules/types-constants-audit.mdc` | Project rule. |
| Windsurf | `.windsurf/rules/types-constants-audit.md` | Project rule. |
| Cline | `.clinerules/types-constants-audit.md` | Project rule. |
| Kiro | `.kiro/steering/types-constants-audit.md` | Steering rule. |
| Generic agents | `SKILL.md` or `AGENTS.md` | Copy the compact rule file or load the full skill. |

## Adapter Rule

Keep adapters thin. If a host supports skills, point it at `SKILL.md`, `references/`, and `scripts/`. If a host only supports project instructions, keep its copied rule text aligned with `AGENTS.md`.

Do not duplicate detailed placement rules in every adapter. Detailed guidance belongs in:

- `references/audit-heuristics.md`
- `references/placement-rules.md`
- `references/report-format.md`

## Release Rule

Update `package.json` version and tag the repo when behavior changes are ready to publish. Patch versions are for documentation, compatibility adapters, and scanner bug fixes. Minor versions are for new audit capabilities.

## Commands

OpenCode supports project commands under `.opencode/command/`. This repo does not ship commands yet because v0.1 has a single workflow. Add commands when phase two splits the skill into separate audit modes.
