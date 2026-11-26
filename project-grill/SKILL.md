---
name: project-grill
description: Use at the start of a new project or when a repo has no SPEC.md/DESIGN.md/AGENTS.md. Interviews the user relentlessly about the project, then writes GLOSSARY.md, SPEC.md, DESIGN.md, AGENTS.md and a short README.md.
---

# Project Grill

Interview the user until the project is unambiguous, then write five short context files. Do not write code. Do not write files before the interview is done.

## 1. Prepare (silent)

- Read what exists: README, package/composer/pyproject files, folder tree, any notes the user attached. Never ask what you can read.
- Note what is known, what is missing, what contradicts.

## 2. Grill

Rules:
- Ask 3-5 questions per round, one topic per round. Numbered, short.
- Give a recommended default for every question, so the user can answer "ok" or "1 ok, 2 no: X".
- Challenge vague words ("simple", "fast", "smart", "users"). Ask for a concrete example or number.
- Resolve contradictions immediately; quote both statements.
- If an answer introduces a new term, pin its definition now (feeds GLOSSARY).
- If the user says "you decide", decide, state it in one line, move on.
- Never ask more than ~8 rounds. Prefer fewer, sharper rounds.

Topics, in order:
1. **Purpose**: who is it for, what problem, what does success look like in one sentence, why now.
2. **Scope**: must-have for v1; explicit non-goals (what must NOT be built; removing beats adding); what can wait.
3. **Behavior**: core flows end to end, inputs/outputs, concrete examples, acceptance criteria per flow.
4. **Domain**: entities, their relationships, states and transitions, vocabulary, overloaded or ambiguous words.
5. **Architecture**: stack, hosting, data storage, external services/APIs, auth, local vs deployed, existing code to reuse. For each significant choice (hard to reverse, spans components, or had real alternatives) ask: options considered, why this one, what it costs. These become ADRs.
6. **Constraints**: budget, performance, security/secrets, privacy, legal, deadlines, who operates it.
7. **Failure modes** (invert): "It is 3 months later and this failed. Why?" Then: what are the second-order effects of the main design choices? What is irreversible?
8. **Quality**: how is "done" verified: tests, commands, manual checks, lint, CI.
9. **Agent rules**: conventions, forbidden actions, approval gates, commit/branch rules, where agents must stop and ask.

Exit when: purpose, scope, non-goals, core flows, stack, and "done" are each answered concretely and nothing contradicts.

## 3. Confirm

Before writing, send a summary of at most 15 bullets: purpose, scope, non-goals, flows, stack, key decisions, open risks. Ask: "Correct? Anything missing?" Fix, then write.

## 4. Write

Write to the repo root. These files are loaded into agent context on every run, so every line must earn its tokens.

Global style:
- Terse, imperative, present tense. Bullets and tables over prose. No intro, no filler, no marketing words.
- One fact lives in exactly one file. Link, never duplicate.
- Use only terms defined in GLOSSARY.md, spelled identically everywhere.
- Unknowns: `TODO(question)` in place. Do not invent facts.
- Respect line budgets. If over, cut detail, not decisions.

### GLOSSARY.md (≤ 60 lines)
Table: `Term | Definition | Not to be confused with`. Domain terms, entities, states, project-specific names. One-line definitions. Alphabetical.

### SPEC.md (≤ 150 lines): the WHAT
- **Purpose**: 1-2 sentences.
- **Users**: who, and their main goal.
- **Scope v1**: bullet list.
- **Non-goals**: bullet list. Mandatory.
- **Flows**: per flow: trigger, steps, result, edge cases.
- **Acceptance criteria**: checkable statements (`Given/When/Then` or plain), numbered `AC-1...`, grouped by flow.
- **Constraints & NFRs**: only measurable ones.
- **Open questions**: `TODO(question)` list.
No implementation detail here.

### DESIGN.md (≤ 150 lines): the HOW
- **Stack**: table `Layer | Choice | Why (one line)`.
- **Architecture**: components and responsibilities, data flow (small ASCII diagram if it saves words).
- **Data model**: entities, key fields, relations, state transitions.
- **Interfaces**: endpoints, CLI commands, events, external APIs; signatures only.
- **Structure**: top-level folder map, one line each.
- **Decisions**: index only, one line each: `ADR-0001 <title> (status)`. Detail lives in `docs/adr/`.
- **Risks**: failure modes from the interview and mitigation.
- **Hosting & config**: env vars (names only, never values), deploy target.

### docs/adr/NNNN-title.md (≤ 25 lines each; not loaded by default)
One file per significant decision. Number sequentially (`0001-...`). Skip trivial choices; those go in the DESIGN stack table "Why" column.
```
# ADR-NNNN: <decision as a short phrase>
Status: proposed | accepted | superseded by ADR-NNNN
Date: YYYY-MM-DD
## Context
<problem and constraints, 2-4 lines>
## Decision
<what we do, 1-3 lines>
## Alternatives
- <option>: <why rejected>
## Consequences
- <trade-offs, what gets harder, how to reverse>
```
Accepted ADRs are immutable except Status. To change a decision, add a new ADR and mark the old one superseded.

### AGENTS.md (≤ 80 lines): always loaded, smallest and most important
- **Project**: one line + pointer: "Read GLOSSARY.md first; SPEC.md for what; DESIGN.md for how."
- **Commands**: install, run, test, lint, build. Exact, copy-pasteable.
- **Conventions**: code style, naming, error handling, logging, test placement.
- **Rules**: do / never. Include: read the relevant ADR in `docs/adr/` before changing what it covers; never edit an accepted ADR, supersede it with a new one; never commit secrets; never expand scope beyond SPEC.md; prefer deleting to adding; ask before new dependencies, schema changes, or anything in Non-goals.
- **Workflow**: branch/commit/PR conventions; plan before multi-file changes; run tests before declaring done.
- **Definition of done**: checklist tied to SPEC acceptance criteria.
- **Stop and ask when**: list the project-specific triggers.
- **Keeping docs true**: if code and docs disagree, fix the docs in the same change and note it.

### README.md (≤ 40 lines): for humans
Name, one-sentence purpose, status, quickstart (install/run in ≤ 5 commands), link to SPEC/DESIGN/AGENTS. Nothing else.

## 5. Verify, then hand over

Check, fix, then report in ≤ 5 lines:
- Every SPEC flow has acceptance criteria; every acceptance criterion is testable.
- Every DESIGN component traces to a SPEC flow; nothing in DESIGN violates a non-goal.
- Every ADR in the DESIGN index exists, has a status, and names at least one rejected alternative.
- Terms match GLOSSARY everywhere.
- Line budgets met; no duplicated facts.
- List remaining `TODO(question)` items.

Then ask the user to review the files and stop. Implementation starts only on their go-ahead.
