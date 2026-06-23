# Real Repo Validation Checklist

Use this file while testing Website Shower before a release. The goal is feedback on the skill, not cleanup of the target repo.

## Rules

- [ ] Run audits read-only. Do not edit the target repo.
- [ ] Record the exact command and target path.
- [ ] Keep private names out of public notes.
- [ ] Count useful tasks, false positives, and missed issues.
- [ ] Record whether the report gives a human or agent enough context to act later.

## Repo Mix

- [ ] Small clean website, such as a portfolio or simple Next.js app.
- [ ] Feature-heavy React or Next.js app.
- [ ] Monorepo package or app.
- [ ] Older or messier repo with global `types.ts`, `constants.ts`, or weak checker setup.
- [ ] Repo with Tailwind, when Tailwind cleanup is added.
- [ ] Repo with API routes, generated contracts, or database schema files.

## Baseline Commands

- [ ] Run the full candidate scan:

```bash
MAX_SECTION_LINES=300 scripts/scan-website-shower.sh /path/to/repo
```

- [ ] If `fallow` is installed in the repo or globally, run:

```bash
scripts/scan-unused-code.sh /path/to/repo
```

- [ ] If the repo can use `npx` and you accept network/tool resolution:

```bash
FALLOW_USE_NPX=1 scripts/scan-unused-code.sh /path/to/repo
```

- [ ] Run focused scanners when the full output is too large:

```bash
scripts/scan-file-tree-hygiene.sh /path/to/repo
scripts/scan-typescript-hygiene.sh /path/to/repo
scripts/scan-react-next-habits.sh /path/to/repo
scripts/scan-api-contracts.sh /path/to/repo
scripts/scan-state-domain-contracts.sh /path/to/repo
scripts/scan-types-constants.sh /path/to/repo
```

## Module Checks

### File Tree Hygiene

- [ ] Does it identify the real app, package, and feature boundaries?
- [ ] Does it find mixed folder conventions such as `feature` and `features` without treating migration folders as automatic findings?
- [ ] Does it separate framework-owned route folders from app-owned feature folders?
- [ ] Does it surface junk drawers such as broad `lib`, `utils`, `shared`, or `common` folders?
- [ ] Does it identify generated and build folders that later modules should treat carefully?

### TypeScript Hygiene

- [ ] If the repo is JS-only, does it suggest TypeScript only when there is real contract pressure?
- [ ] Does it detect the repo's checker setup: Biome, ESLint, Prettier, oxlint, knip, or none?
- [ ] Does it recommend missing `tsconfig` strictness only when it fits the repo?
- [ ] If Biome exists, does it spot missing formatter, linter, `noExplicitAny`, `noDebugger`, `useConst`, unused-variable, and Tailwind class rules?
- [ ] If Prettier exists, does it spot missing formatter policy, ignore file, and format script?
- [ ] If ESLint exists, does it spot missing `no-console`, `no-debugger`, `prefer-const`, `eqeqeq`, `@typescript-eslint/no-explicit-any`, TypeScript unused-vars, and React hooks rules?
- [ ] Does it flag `any`, double casts, suppressions, and old JS files without turning safe `unknown` narrowing into a finding?

### React And Next.js Habits

- [ ] Does it detect App Router, Pages Router, or non-Next React shape correctly?
- [ ] Does it flag client hooks in App Router files without treating valid client components as findings?
- [ ] Does it separate metadata and route config repetition from local route-owned values?
- [ ] Does it find repeated fetch cache policies that should become a named convention?
- [ ] Does it find route literals that cross navigation, redirects, fetch calls, and tests?

### Tailwind Cleanup

- [ ] If Tailwind is absent, does the module skip cleanly?
- [ ] If CSS exists without Tailwind, does it suggest Tailwind only as an optional transition lead?
- [ ] Does it detect Tailwind through package config, Tailwind config files, or CSS directives?
- [ ] Does it find unclear source/content coverage in monorepos and app folders?
- [ ] Does it flag dynamic class construction that Tailwind cannot detect reliably?
- [ ] Does it surface repeated arbitrary values, duplicate utilities, and long class strings without treating every local class list as a finding?

### API Contracts

- [ ] Does it detect route handlers, Pages API routes, or plain fetch clients?
- [ ] Does it find request body parsing without runtime validation?
- [ ] Does it find duplicated request/response/payload types across routes, clients, mocks, schemas, or tests?
- [ ] Does it respect generated OpenAPI, GraphQL, protobuf, or SDK output as a weak signal?
- [ ] Does it recommend one clear owner instead of moving every API type to a global file?

### State And Domain Contracts

- [ ] Does it find the actual store, state, reducer, selector, event, and domain folders?
- [ ] Does it separate store-derived `RootState` or `AppState` from hand-written duplicate state contracts?
- [ ] Does it find event payloads that repeat across producer, consumer, worker, route, or reducer?
- [ ] Does it find status machines repeated across store, UI, API client, and tests?
- [ ] Does it avoid treating separate `loading`, `error`, or `pending` lifecycles as one shared owner?

### Types And Constants

- [ ] Does the scanner find duplicated type/interface names worth inspecting?
- [ ] Does it separate real domain literals from local UI strings?
- [ ] Does it catch raw literals that bypass existing owners?
- [ ] Does it avoid generated files, route handlers, and framework noise?
- [ ] Does the final report cite exact file paths and line numbers?

### Unused Code

- [ ] Does `fallow` produce better leads than the fallback on this repo?
- [ ] Does the fallback label its output as leads, not deletion proof?
- [ ] Are framework entrypoints, config files, public exports, and dynamic imports handled as weak signals?
- [ ] Did any stale helper, dependency, or export become a useful task?

### Future Modules

- [ ] Monorepo ownership: feature-private imports, premature shared packages, app-global junk drawers, and cross-package drift.
- [ ] Generated-code boundary: generated files mixed with hand-written code, stale generated contracts, and missing ignore guidance.
- [ ] Naming drift: same concept named `status`, `state`, `phase`, `mode`, `kind`, or `type` across owners.

## Report Quality

- [ ] The final report has 5-15 useful tasks or leads for a non-trivial repo.
- [ ] Each task has a stable ID, module, confidence, files, reason, safe action, validation, and permission status.
- [ ] Ignored leads explain why they were ignored.
- [ ] Setup leads are grouped; missing Biome, Prettier, and ESLint should not become separate tasks if the repo only needs one formatter path and one lint path.
- [ ] The report is useful without scanner output open beside it.

## Feedback Template

```md
Target:
Repo shape:
Command:
Modules tested:
Useful tasks:
False positives:
Missed issues:
Rule or scanner change needed:
Would I trust an agent to act from the report after permission? yes/no
Notes:
```
