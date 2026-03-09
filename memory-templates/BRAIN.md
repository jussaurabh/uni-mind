# Uni-Mind

Central memory for all BMAD agents across all projects.
Read this file at the start of every session.

## How to Use This Memory

- **START** of session: Read this file + the relevant project context
- **DURING** work: Append decisions, patterns, lessons to relevant files
- **END** of session (when asked): Summarize what happened in `journal/<project-name>/YYYY-MM-DD.md` (use TODAY's date; create new file if needed — one file per day)

## Active Projects

- [general](projects/general/context.md) — Default lane for cross-project work, ideation, or unspecified tasks
<!-- Add more with memory-new. Example: -->
<!-- - [my-product](projects/my-product/context.md) — Short description -->

## Quick Reference

- [My preferences](identity/preferences.md) — Coding style, communication, pet peeves
- [My conventions](identity/conventions.md) — Git, file org, naming
- [My tech stack](identity/stack.md) — Languages, frameworks, infra
- [Recent journal](journal/) — One file per day (YYYY-MM-DD.md). Check last 3 days in `journal/<project-name>/`. Can read any project and any date when needed.

## Memory Structure

- `identity/` — About you (permanent preferences, conventions, stack)
- `projects/` — Per-product knowledge (context, decisions, patterns, lessons)
- `procedures/` — Cross-project workflows (debug, deploy, review)
- `journal/<project-name>/` — Daily work log per project. One file per calendar day (YYYY-MM-DD.md). Use `general/` for cross-project. Can read any project and any date for historical context.
- `agents/` — Agent-specific learned behaviors
