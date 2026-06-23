# Example Before/After Types And Constants Audit

This is an anonymized read-only audit report. It demonstrates the before/after judgment step: raw scanner output becomes a small set of useful findings, and noisy leads are ignored.

## Scope

- Target: `examples/fixture`
- Shape: small TypeScript app with `src/state`, `src/feature`, and `src/ui`
- Mode: read-only
- Command:

```bash
MAX_SECTION_LINES=80 scripts/scan-types-constants.sh examples/fixture
```

## Before: Scanner Signals

- Candidate owner file: `src/state/contracts.ts`
- Repeated names: `AppState`, `WorkItem`, `DomainEvent`, `ResourceMap`
- Repeated unions: `'left' | 'right'`, `'queued' | 'done' | 'error'`
- Existing owner union: `ProcessStep = 'draft' | 'active' | 'archived'`
- Ignored UI lead: local `default` variants in `src/ui/control.ts`

The scanner also reported `AppState`, `ProcessStep`, and repeated watched literals such as `draft`, `active`, and `archived`. Those are kept as leads until usage proves they are real drift.

## After: Findings

1. Duplicated type: `WorkItem`
   Severity: medium
   Confidence: high

   Current:
   - `examples/fixture/src/state/contracts.ts:11`
   - `examples/fixture/src/state/feature/workSlice.ts:3`

   Recommendation:
   Keep `WorkItem` in `src/state/contracts.ts` and import it from the feature slice.

   Reason:
   The same item contract is declared by the state owner and again inside the state feature slice. The duplicated `side` and `status` fields can drift when the item model changes.

   Next action:
   Replace the local `WorkItem` interface in `workSlice.ts` with an import from `../contracts`.

2. Duplicated literal union: `'queued' | 'done' | 'error'`
   Severity: medium
   Confidence: high

   Current:
   - `examples/fixture/src/state/contracts.ts:14`
   - `examples/fixture/src/state/feature/workSlice.ts:6`

   Recommendation:
   Export a named `WorkStatus` type from `src/state/contracts.ts` and use it in both `WorkItem` declarations while removing the duplicate local `WorkItem`.

   Reason:
   This status set controls runtime filtering in `workSlice.ts`. If the state contract adds a status and the slice does not, selectors and item creation can silently diverge.

   Next action:
   Create `export type WorkStatus = 'queued' | 'done' | 'error';` beside the state contract, then use `status: WorkStatus`.

3. Duplicated type: `DomainEvent`
   Severity: medium
   Confidence: high

   Current:
   - `examples/fixture/src/state/contracts.ts:17`
   - `examples/fixture/src/feature/consumeEvent.ts:1`

   Recommendation:
   Import `DomainEvent` from `src/state/contracts.ts` in `consumeEvent.ts`.

   Reason:
   The consumer redefines the event payload shape owned by the state contract. Event payloads are drift-prone because producers and consumers often change at different times.

   Next action:
   Delete the local `DomainEvent` interface from `consumeEvent.ts` and use the owned contract.

4. Duplicated literal union: `'left' | 'right'`
   Severity: low
   Confidence: medium

   Current:
   - `examples/fixture/src/state/contracts.ts:13`
   - `examples/fixture/src/state/feature/workSlice.ts:5`
   - `examples/fixture/src/state/feature/workSlice.ts:9`
   - `examples/fixture/src/feature/consumeEvent.ts:15`

   Recommendation:
   Introduce a named `WorkSide` type only if `left` and `right` are domain concepts, not just local UI placement.

   Reason:
   The union repeats across state and feature boundaries, but the name `side` is still ambiguous. It could be domain state or a UI direction. This needs ownership confirmation before moving.

   Next action:
   Check whether `selectedSide` is persisted domain state or only a UI selection. If it is domain state, define `WorkSide` near `WorkItem`.

5. Repeated type name: `ResourceMap`
   Severity: low
   Confidence: medium

   Current:
   - `examples/fixture/src/feature/sourceData.ts:1`
   - `examples/fixture/src/feature/preloadData.ts:1`

   Recommendation:
   Move `ResourceMap` to a nearby feature-owned file only if both modules are production code and intentionally share the same resource shape.

   Reason:
   The duplicated shape is real, but both files are close together and may be independent fixtures or generated data inputs. This is a cleanup lead, not a high-confidence drift issue.

   Next action:
   Confirm whether these files are generated, fixture-only, or production-owned before extracting a shared type.

## Ignored Leads

- `AppState` appears twice: `src/state/index.ts` derives it from `store.getState`, while `src/state/contracts.ts` declares a small fixture interface. In a real repo, this would need inspection before reporting; store-derived state often wins over hand-written aliases.
- `ProcessStep` and raw `'draft' | 'active' | 'archived'` appear near each other, but the only raw usage is inside one feature data helper. This is a possible follow-up, not a top finding.
- `default` appears in `src/ui/control.ts`; this is a local UI variant, not a domain constant.
- No repeated primitive constants were found.

## Summary

Found 3 medium-confidence contract drift issues and 2 lower-confidence cleanup leads. The safest first edit would be to remove the local `WorkItem` and `DomainEvent` duplicates by importing from `src/state/contracts.ts`.

No files were modified during this audit.
