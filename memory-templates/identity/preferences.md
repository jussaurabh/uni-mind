# Preferences

## Coding Style

- Readable over clever — always
- Keep it simple (KISS) — no over-engineering
- DRY — extract when repetition becomes a pattern, not preemptively
- Strong typing — explicit types, use TypeScript strict mode
- Both functional and OOP patterns — pick what fits the context
- Early returns and guard clauses for cleaner flow
- Tests are optional — skip unless explicitly requested. Manual testing is the norm.

## Error Handling

- try/catch with custom error classes as the default
- Guard clauses + early returns for simple validation
- Context-dependent — no single dogma, pick what fits

## Comments

- Code should be self-documenting
- Comments only explain WHY, never narrate WHAT the code does
- Never add comments like "// Import the module" or "// Handle the error"
- Never add comments explaining a change being made

## Communication Style

**During coding and implementation:**
- Ultra-direct, no fluff, just code and done
- Don't explain obvious things
- Don't ask permission for small decisions — just do them
- Show code first, explain after (only if needed)

**During planning, brainstorming, and architecture:**
- Be interactive and proactive
- Challenge my theories and ideas — counter-attack my solutions
- Present alternatives I haven't considered
- Ask hard questions before jumping to conclusions
- Always research well before providing a solution

**Always:**
- Explain with real-world scenarios and practical examples, not abstract theory
- When I ask "how does X work", show me a concrete example first, then explain

## UX Design Specs

- One spec file per page (or tightly related page group). Do NOT pile all pages into a single spec file.
- Path pattern: `_bmad-output/planning-artifacts/ux-<page-name>.md`
- If a spec file is getting large (500+ lines), it is already too big — split.
- The auth pages spec (`ux-design-specification.md`) was the first and is an exception; do not add more pages to it.

## Pet Peeves — NEVER DO THESE

- Do NOT be verbose when I need code written — get to the point
- Do NOT ask permission for every small thing — use judgment
- Do NOT use patterns that don't match the existing codebase — read the project first
- Do NOT hallucinate APIs, functions, or libraries that don't exist — verify
- Do NOT create new files or utilities when similar ones already exist in the project
- Do NOT force writing tests unless I explicitly ask for them
- Do NOT remove my console.log statements — leave them alone
- Do NOT remove my comments when updating code
