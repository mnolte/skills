---
name: "debug"
description: "Use when a bug, failing test, error or unexpected behaviour blocks work during defining or building, or when a fix attempt has already failed once."
---

# Debug

Find the root cause, fix it completely, change nothing else, and get back to the work the bug interrupted. No fix without a reproduction. No guessing.

## 0. Save the thread (1 minute)

Before touching anything, write down in one line each:
- **Was doing:** the task the bug interrupted.
- **Symptom:** expected vs. actual, with the exact error text.

This is what you return to in step 6.

## 1. Triage: fix now, park, or rethink

Decide explicitly and say which:

| Situation | Action |
|---|---|
| Blocks the current task | Fix now (continue to step 2) |
| Does not block the current task | Park: add an entry to `BUGS.md` (symptom, repro steps if known, date), then return to the task |
| The bug exists because the spec or design is wrong or silent | Rethink: go to step 5 before writing any fix |

## 2. Reproduce

- Get a reliable repro: a failing test if possible, otherwise an exact command or click path.
- Shrink it to the smallest input that still fails.
- If it cannot be reproduced after an honest attempt: add logging at the boundary where it occurs, park it in `BUGS.md` with what was tried, and stop. Do not fix what you cannot see fail.

## 3. Find the root cause

- Read the full error and stack trace first. Check what changed last (`git log`, `git diff`).
- State one hypothesis: "X fails because Y". Name the observation that would prove it wrong.
- Test it with one change or one log line. One variable at a time.
- Wrong? Revert the experiment, write down what it ruled out, form the next hypothesis.
- **Stop rule:** after 3 failed hypotheses, stop and report: what is known, what is ruled out, and the options (bisect with `git bisect`, add instrumentation, question the design in step 5, or park). Ask the user which.

The root cause is found when you can explain every part of the symptom and predict when it does and does not occur.

## 4. Fix

- Turn the repro into a failing regression test first (if step 2 did not already produce one).
- Make the smallest change that fully removes the cause. A patch that hides the symptom is not a fix.
- If fully removing the cause requires a redesign, stop and go to step 5 instead of patching.
- The diff contains the fix and its test only. Unrelated refactors and improvements found on the way go in `BUGS.md` as follow-ups.
- Run the regression test, then the full test suite. Show the output.
- Remove all temporary logging and experiments.

## 5. Feed back into the docs

A bug is new information. Ask: why was this possible?

| Cause | Update |
|---|---|
| Spec was silent or ambiguous | `SPEC.md`: add the rule or acceptance criterion |
| A design decision was wrong, or a new one was made | New ADR in `docs/adr/`; update the index in `DESIGN.md` |
| A term meant two things | `GLOSSARY.md` |
| An agent will repeat this mistake | One line in `AGENTS.md` |
| Plain coding slip | Nothing; the regression test is enough |

If the finding changes the direction of the project or requires a redesign, stop and tell the user before continuing: state the cause, the proposed new design, and what it replaces. Changing strategy is a valid outcome; doing it silently is not.

## 6. Return

Report in this shape, then resume the task from step 0:

- **Cause:** one sentence.
- **Fix:** files changed.
- **Proof:** regression test name and suite result.
- **Docs updated:** list, or "none".
- **Follow-ups:** entries added to `BUGS.md`, or "none".
- **Resuming:** the interrupted task.

## Done when

- The repro fails before the fix and passes after it.
- The full suite passes.
- No temporary debug code remains.
- Docs are updated per step 5, or explicitly "none".
- Parked bugs and follow-ups are in `BUGS.md`.