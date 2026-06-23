# State And Domain Contract Audit

Use this module when a repo has app state, stores, reducers, selectors, event payloads, workflow statuses, or domain machines.

## Tool

```bash
scripts/scan-state-domain-contracts.sh <target>
```

For a full Website Shower pass:

```bash
scripts/scan-website-shower.sh <target>
```

The scanner reports leads for:

- state, store, domain, reducer, action, selector, event, and machine files
- `State`, `Store`, `Slice`, `Action`, `Event`, `Payload`, `Status`, `Phase`, `Mode`, and `Machine` type names
- state creators, action creators, selectors, and hooks
- event and action string literals
- status-machine literals
- repeated state/domain contract names

## Judgment

Strong signals:

- a store-owned state shape is duplicated by a feature slice or hook
- event payloads repeat between producer, consumer, worker, route, or reducer
- selector return shapes are hand-written in consumers instead of inferred or imported
- the same status machine is repeated across store, UI, API client, and tests
- action names or event names repeat as raw strings across owners
- a feature imports private state contracts from another feature

Weak signals:

- `AppState` or `RootState` derived from the store with `ReturnType`
- local reducer actions that never cross the component boundary
- repeated words such as `loading` or `error` that belong to separate lifecycles
- test-only event builders and partial fixtures
- generated state or API clients that should stay generated

## Follow-Up

Before reporting a task:

```bash
rg "RootState|AppState|ReturnType<typeof.*getState|configureStore|createSlice|zustand|atom\\(" <target>
rg "select[A-Z]|use[A-Z].*Store|dispatch\\(|type: '" <target>
rg "Status|Phase|Mode|Event|Payload|Action" <target>
```

Good tasks name one owner: store-derived type, feature domain model, event contract file, schema, or generated contract. Do not create a global `state/types.ts` unless unrelated state owners truly share that contract.
