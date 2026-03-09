# Common Tech Stack

## Languages

- **TypeScript** — Always for frontend. Often for backend (NestJS).
- **JavaScript** — Backend when TS isn't set up.
- **Python** — Backend services, scripting, data work.
- **Go** — Backend services (exploring, not primary).

## Frontend

- **Framework:** React 18+
- **Build:** Vite
- **Styling:** Tailwind CSS + ShadCN UI
- **State (client):** Zustand or Redux (varies by project)
- **State (server):** TanStack Query
- **Forms:** react-hook-form
- **Validation:** zod
- **Package manager:** bun (preferred), sometimes npm

## Backend

- **Primary:** NestJS + MongoDB (personal projects)
- **Secondary:** Fastify + MongoDB (exploring)
- **Company stack:** NestJS, Fastify, MongoDB, Elasticsearch
- **ORM/ODM:** Mongoose (for MongoDB)
- **API style:** REST (primary), may explore GraphQL later

## Auth

- **Provider:** Auth0 (authentication only — email/password, JWT)
- **Authorization:** Roles, permissions, organizations stored in MongoDB, not Auth0

## Infrastructure

- **Hosting (personal):** Railway
- **Hosting (company):** Managed by company infra team
- **CI/CD:** None on personal projects yet. Interested in learning GitHub Actions.
- **Containers:** Familiar with Docker basics. Not using Kubernetes.

## Testing

- Rarely writes automated tests — manual testing is the norm
- No strong framework preference
- Tests are optional unless explicitly requested
- Interested in learning testing best practices as projects grow

## Database

- **Primary:** MongoDB (single DB, tenant field on documents for multi-tenancy)
- **Search:** Elasticsearch (company projects)
