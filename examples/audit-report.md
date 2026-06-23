# Example Audit Report

This is an anonymized example of the expected report shape. It is not copied from a real project.

## Target

- Shape: TypeScript web app with `src/state`, `src/feature`, and `src/ui`
- Mode: read-only
- Scanner: `scripts/scan-types-constants.sh examples/fixture`

## Findings

1. `AppState` duplicated between state owner and feature slice
   Severity: medium
   Confidence: high

   Current:
   - `src/state/contracts.ts`
   - `src/state/feature/workSlice.ts`

   Recommendation:
   Keep `AppState` in `src/state/contracts.ts` and import it from the feature slice.

   Reason:
   The feature slice is re-declaring the state contract owned by the state module. This can drift when the state shape changes.

   Next action:
   Replace the local alias with an import from the state contract owner.

2. `'queued' | 'done' | 'error'` repeated as a status union
   Severity: medium
   Confidence: high

   Current:
   - `src/state/contracts.ts`
   - `src/feature/consumeEvent.ts`

   Recommendation:
   Export one `WorkStatus` union from the state contract owner and reuse it at the consumer boundary.

   Reason:
   The same runtime status set appears in both the state contract and feature consumer. If one side adds a status, the other can silently drift.

   Next action:
   Import the owned status union where the event is consumed.

3. `ResourceMap` duplicated near preload/source data
   Severity: low
   Confidence: medium

   Current:
   - `src/feature/sourceData.ts`
   - `src/feature/preloadData.ts`

   Recommendation:
   Keep this local if the files are intentionally independent fixtures. Otherwise move the shared shape to the nearest feature owner.

   Reason:
   The shape is repeated, but ownership depends on whether the data files are examples, fixtures, or production inputs.

   Next action:
   Check whether either file is test-only or generated before moving it.

## Ignored Leads

- Repeated `default` in UI code: likely a local UI variant, not a domain constant.
- Repeated primitive values: no shared semantic owner was visible.
- Generic names like `State` or `Props`: only findings when shape and ownership match.

## Summary

The useful findings are about duplicated contracts near state and feature boundaries. No edits were performed.
