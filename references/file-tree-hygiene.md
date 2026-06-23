# File Tree Hygiene Audit

Use this module first. It gives the map for every later Website Shower section: app layout, package boundaries, feature folders, generated output, framework-owned routes, and junk drawers.

## Tool

```bash
scripts/scan-file-tree-hygiene.sh <target>
```

For a full Website Shower pass:

```bash
scripts/scan-website-shower.sh <target>
```

The scanner reports leads for:

- root config and workspace signals
- top-level directories
- app, package, service, worker, and function folders
- feature and UI boundary folders
- mixed folder conventions
- junk-drawer files and folders
- generated and build output boundaries
- route layout
- unusually deep source files

## Judgment

Strong signals:

- both `src/feature` and `src/features` exist without a clear migration reason
- both `src/components` and `src/ui` hold similar shared UI primitives
- `lib`, `utils`, `shared`, or `common` contain unrelated feature code
- generated files sit beside hand-written code without naming or ignore guidance
- route files import deeply into private feature internals across ownership boundaries
- app/package folders use different naming styles for the same concept

Weak signals:

- framework-owned folders such as `app`, `pages`, `api`, or route groups
- a small repo with one `utils.ts` file and no real ownership pressure
- generated folders that are clearly isolated and ignored by tooling
- deep files inside route groups or colocated tests that match repo convention
- temporary migration folders with clear names and short lifetime

## Follow-Up

Before reporting a task:

```bash
find <target> -maxdepth 3 -type d
rg --files <target> | rg '(^|/)(feature|features|components|ui|lib|utils|shared|common)/'
rg --files <target> | rg 'generated|__generated__|dist|build|\\.next'
```

Good tasks name one boundary to clean. Do not ask for a large folder rewrite unless the repo already has a clear target convention.
