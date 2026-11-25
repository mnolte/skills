---
name: implement-spec
description: Use to bring a codebase in line with SPEC.md and DESIGN.md. Audits code against every acceptance criterion and design decision, reports gaps, then fixes divergences and writes missing code, test-first. Use after project-grill, after spec changes, or before release.
---

# Implement Spec

Make the code match SPEC.md (what) and DESIGN.md (how). Audit first, then change. The spec is the target; do not invent scope.

## 1. Load context

Read in order: AGENTS.md, GLOSSARY.md, SPEC.md, DESIGN.md. Use GLOSSARY terms exactly in code, names and tests.
If SPEC.md or DESIGN.md is missing or has unresolved `TODO(question)` that blocks work, stop and run the `project-grill` skill or ask. Do not guess.

## 2. Audit (read-only)

Build a traceability table. One row per item:
- every acceptance criterion `AC-n` in SPEC
- every flow and non-goal in SPEC
- every component, interface, data-model entity and `D-n` decision in DESIGN

| Item | Status | Evidence |
|---|---|---|

Status values:
- **met**: implemented and a test or command proves it
- **untested**: implemented, no proof
- **partial**: some paths or edge cases missing
- **missing**: nothing exists
- **diverges**: code does something different from spec/design
- **violates**: code implements a non-goal or breaks a decision
- **extra**: code does something the spec never asked for

Evidence is `path:line`, a test name, or a command result. Run the AGENTS.md test/lint/build commands for real; never claim "met" from reading alone. Check for dead code, stray TODOs, hardcoded secrets and config drift against DESIGN.

## 3. Decide

Present the table (omit met rows if long, just count them) and a proposed change list, ordered by dependency and risk. For each non-met row, resolve who is right:
- Default: spec/design wins; fix the code.
- If the code looks deliberate and better, or the spec is wrong or stale: do not choose silently. Ask, and update the doc if the user agrees.
- `extra` and `violates`: propose removal. Never delete working code without approval.

Ask before proceeding if: the change list touches more than ~10 files, needs a new dependency, schema migration, or public interface change, or conflicts with a non-goal. Otherwise state the plan in a few lines and continue.

## 4. Implement

Work in small slices: one AC or tightly related group at a time.
1. Write or extend a failing test that encodes the AC (or a runnable check if tests don't fit).
2. Make the smallest change that passes. Follow AGENTS.md conventions; reuse existing code; prefer deleting to adding.
3. Run the full test/lint/build commands. Fix regressions before moving on.
4. Commit per slice: `AC-n: <what>`; follow AGENTS.md git rules.

Rules:
- Stay inside SPEC scope. Anything useful but unspecified goes in the report as a suggestion, not in the code.
- Architecture changes must match DESIGN. If a better structure is needed, propose a DESIGN update first.
- No secrets in code or commits; env var names only.
- If blocked or the spec turns out ambiguous mid-task, stop that slice, note it, continue with others, ask at the end.

## 5. Sync docs

If a decision changed during work, update SPEC/DESIGN/GLOSSARY in the same change, in place, within their line budgets. Add or close `TODO(question)` entries. Keep README quickstart true (run it).

## 6. Re-audit and report

Re-run the audit on touched rows. Report in ≤ 12 lines:
- counts per status, before and after
- what changed (by AC)
- what remains and why (blocked, needs decision, out of scope)
- doc updates made
- suggestions that were deliberately not built

Do not mark the work done while any AC is `missing`, `partial` or `diverges` without a stated reason.
