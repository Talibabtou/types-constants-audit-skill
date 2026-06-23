# API Contract Hygiene Audit

Use this module when a website repo has API routes, route handlers, fetch clients, schemas, mocks, or generated API types.

## Tool

```bash
scripts/scan-api-contracts.sh <target>
```

For a full Website Shower pass:

```bash
scripts/scan-website-shower.sh <target>
```

The scanner reports leads for:

- route handler files
- request body parsing
- JSON response boundaries
- API fetch clients
- schema validation calls
- request, response, payload, DTO, params, and result type names
- mock and fixture API shapes

## Source Basis

Next route handlers use standard Web `Request` and `Response` APIs, and can return JSON responses. That makes route files natural API contract owners when no separate schema layer exists.

Request bodies from forms, JSON, webhooks, workers, or external clients need runtime validation. TypeScript annotations alone do not validate external input.

Schema tools such as Zod expose `parse` and `safeParse`; if a repo already uses a schema tool, prefer deriving API types from that owner instead of hand-writing parallel request and response types.

## Judgment

Strong signals:

- route, client, and mock each declare their own copy of the same request or response shape
- route parses `request.json()` and immediately casts or annotates the result
- response shape is duplicated between handler, client hook, test, and mock data
- schema exists but route/client code uses hand-written DTOs instead
- generated API contracts are edited by hand or mixed with app-owned types
- API path strings repeat across route handlers, clients, mocks, and tests

Weak signals:

- tiny one-off route with local private shape
- generated OpenAPI, GraphQL, protobuf, or SDK output that should stay generated
- route-specific response type that is not imported anywhere else
- tests with intentionally partial mock data
- framework `Request`, `Response`, `NextRequest`, or `NextResponse` names

## Follow-Up

Before reporting a task:

```bash
rg "request\\.json|formData\\(|Response\\.json|NextResponse\\.json" <target>
rg "fetch\\(.*api|/api/" <target>
rg "Request|Response|Payload|Dto|DTO|Result" <target>
rg "z\\.object|safeParse|parse\\(" <target>
```

Good tasks name one owner: route-local schema, feature-local API contract, generated SDK, or shared domain schema. Do not ask for a shared package unless two unrelated owners really consume the same contract.
