# TypeScript Hygiene Audit

Use this module to find typed-code cleanup tasks that reduce drift without changing app behavior.

## Tool

```bash
scripts/scan-typescript-hygiene.sh <target>
```

For a full Website Shower pass:

```bash
scripts/scan-website-shower.sh <target>
```

The scanner reports leads for:

- checker config presence: Biome, ESLint, Prettier, oxlint, knip
- package scripts for lint, format, typecheck, and dead-code checks
- TypeScript compiler guardrails such as `strict`, indexed access, and optional property behavior
- missing Biome, Prettier, or ESLint rules when those tools are present
- `any`, `unknown`, and double-cast pressure
- broad `as SomeType` assertions near app code
- `@ts-ignore`, `@ts-expect-error`, and `@ts-nocheck`
- JavaScript files under `src/` in otherwise typed repos
- hand-written API-style request, response, payload, and DTO names
- JS-to-TS migration leads when JavaScript source exists without TypeScript

## Checker Guardrails

Do not force every repo onto the same checker. First identify the stack already in use, then recommend missing guardrails for that stack.

### TypeScript

Common strictness leads:

- `strict: true`
- `noImplicitAny: true`, unless `strict` already covers the repo's intended baseline
- `noUncheckedIndexedAccess: true`
- `exactOptionalPropertyTypes: true`
- `noImplicitOverride: true` for class-heavy repos

### Biome

Biome can cover formatting and linting in one tool. If a repo uses Biome, look for:

- formatter enabled with stable indentation, line width, quotes, semicolons, and trailing comma policy
- linter enabled
- `suspicious/noExplicitAny`
- `suspicious/noDebugger`
- `style/useConst`
- `correctness/noUnusedVariables`
- Tailwind helpers when Tailwind is present: `nursery/useSortedClasses` and `assist.actions.source.noDuplicateClasses`

For Tailwind class helpers, include the project functions when they exist: `cn`, `clsx`, `cva`.

### Prettier

Prettier is the common formatter alternative to Biome. If a repo uses Prettier, look for:

- a config file such as `.prettierrc`, `prettier.config.js`, or package-level Prettier config
- an ignore file for generated files and build output
- stable quote, semicolon, trailing comma, and print width policy
- a package script such as `format` or `format:check`

Prettier does not replace ESLint for code-quality rules. A typical setup is Prettier for formatting plus ESLint for TypeScript, React, and bug-risk rules.

### ESLint

If a repo uses ESLint, common strict rules include:

- `no-console` as warn, usually allowing `warn` and `error`
- `no-debugger` as error
- base `no-unused-vars` off when TypeScript handles unused variables
- `prefer-const`
- `eqeqeq`, often with `null: ignore`
- `@typescript-eslint/no-explicit-any`
- `@typescript-eslint/no-unused-vars` with `_` ignore patterns
- `react-hooks/exhaustive-deps` for React and Next.js repos

For Next.js, expect `eslint-config-next/core-web-vitals` and `eslint-config-next/typescript` or the repo's current equivalent.

### Other Checkers

Useful package scripts:

- `typecheck`, usually `tsc --noEmit`
- `lint`
- `format` or `format:check`
- dead-code checks through `fallow`, `knip`, or `ts-prune`

Report these as setup leads, not mandatory edits. A small library, generated package, or legacy app may have a good reason to delay strictness.

## Judgment

Strong signals:

- JS-only repo has shared contracts, API boundaries, workers, forms, or long-lived domain logic
- no checker config in a TypeScript website repo
- a checker exists but misses the repo's own strict conventions
- `package.json` has no repeatable script for typecheck or lint
- a repo uses Prettier but has no format script or ignore file
- `any` crosses a network, database, worker, storage, or form boundary
- double casts hide a mismatch that has a real owner
- suppression comment has no reason or points at stale code
- hand-written API types duplicate schema, route, client, hook, or mock types
- old `.js` or `.jsx` files live beside TypeScript feature code

Weak signals:

- small JS-only site with little state, no shared contracts, and no build-time type pressure
- a repo uses a different checker with equivalent rules
- a rule is disabled in generated, vendored, or migration-only folders
- isolated `unknown` that gets narrowed immediately
- test-only casts
- third-party library adapter code
- generated files
- config files loaded by convention
- deliberate public package compatibility shims

## Follow-Up

Before reporting a cleanup task:

```bash
rg "\\bSymbolName\\b" <target>
rg "@ts-ignore|@ts-expect-error|@ts-nocheck" <target>
rg "as unknown as|as any|: any" <target>
```

Report the smallest safe action. Good tasks remove one escape hatch, move one boundary type to its owner, convert one migration leftover, or suggest TypeScript migration only when the repo has enough contract pressure to justify it. If a type assertion is the only reasonable bridge to a third-party library, leave it alone and say why.
