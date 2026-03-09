# Conventions

## Git

- **Commits:** Conventional commits — `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`
  - Short description on the first line
  - Optional body for context when the change is non-trivial
- **Branching:** `main` + feature branches. PR to merge.
  - Branch names: `feature/short-description`, `bugfix/short-description`, `hotfix/short-description`
- **Merge strategy:** Squash merge PRs into main

## Frontend File Organization

Feature folders with type subfolders:

```
src/
├── features/
│   ├── auth/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── utils/
│   │   └── types/
│   ├── dashboard/
│   │   ├── components/
│   │   ├── hooks/
│   │   └── types/
│   └── ...
├── shared/
│   ├── components/    # Reusable UI components
│   ├── hooks/         # Shared hooks
│   ├── utils/         # Shared utilities
│   └── types/         # Shared types
└── ...
```

## Backend File Organization (NestJS)

Standard NestJS module pattern:

```
src/
├── modules/
│   ├── auth/
│   │   ├── auth.module.ts
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   ├── dto/
│   │   └── entities/ (or schemas/ for MongoDB)
│   ├── users/
│   │   ├── users.module.ts
│   │   ├── users.controller.ts
│   │   ├── users.service.ts
│   │   ├── dto/
│   │   └── schemas/
│   └── ...
├── common/
│   ├── decorators/
│   ├── guards/
│   ├── interceptors/
│   ├── filters/
│   └── pipes/
└── config/
```

## Naming

- **Components:** PascalCase (`SalarySlip.tsx`, `UserProfile.tsx`)
- **Hooks:** camelCase prefixed with `use` (`useAuth.ts`, `useSalaryData.ts`)
- **Utilities:** camelCase (`formatCurrency.ts`, `parseDate.ts`)
- **Types/Interfaces:** PascalCase, no `I` prefix (`User`, not `IUser`)
- **API endpoints:** kebab-case (`/salary-slips`, `/user-invites`)
- **Files (general):** kebab-case for non-component files (`auth.service.ts`, `salary-slip.dto.ts`)
- **Environment variables:** SCREAMING_SNAKE_CASE (`DATABASE_URL`, `AUTH0_CLIENT_ID`)
