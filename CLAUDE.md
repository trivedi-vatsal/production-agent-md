# Agent Operating Manual for Production Codebases

Hooks handle verification mechanically. This file handles everything hooks
can't enforce: how you think, how you plan, how you manage context.

---

## Session Artifacts

These files persist state across sessions and sub-agents. Treat them as
first-class project files.

- **gotchas.md** - log every mistake pattern after a correction. Review at
  session start.
- **context-log.md** - written before /compact or agent handoff. Captures
  current task state, open questions, and files in flight so forks can
  pick up cleanly.

---

## Planning

- When asked to plan: output only the plan. No code until told to proceed.
- When given a plan: follow it exactly. Flag real problems and wait.
- For non-trivial features (3+ steps or architectural decisions): ask <=3
  targeted questions in a single response before writing code. Cover
  implementation approach, UX implications, and key tradeoffs. No more
  questions than that.
- Never attempt multi-file refactors in one response. Break into phases of
  max 5 files. Complete, verify (hooks will enforce this), get approval,
  then continue.
- **Mid-task ambiguity**: if requirements turn out to be ambiguous during
  execution, stop at the nearest safe checkpoint. Ask one specific question.
  Don't guess and keep going.

---

## Code Quality

- If architecture is flawed, state is duplicated, or patterns are
  inconsistent: propose and implement the structural fix. Ask: "What would
  a senior perfectionist dev reject in code review?" Fix that.
- Write code that reads like a human wrote it. No robotic comment blocks.
  Default to no comments. Only comment when the WHY is non-obvious.
- Don't build for imaginary scenarios. Simple and correct beats elaborate
  and speculative.

---

## Testing

- Run existing tests after any non-trivial change. A passing hook is not a
  passing test suite.
- If the project has no tests for a modified path: note the gap, don't
  silently skip.
- When asked to verify your own output: adopt a new-user persona. Walk
  through as if you've never seen the project.

---

## Context Management

- Before ANY structural refactor on a file >300 LOC: first remove all dead
  props, unused exports, unused imports, debug logs. Commit cleanup
  separately. Dead code burns tokens that trigger compaction faster.
- For tasks touching >5 independent files: launch parallel sub-agents
  (5-8 files per agent). Each gets its own context window. Sequential
  processing of 20 files often causes meaningful context decay before
  you finish.
- After 10+ messages: re-read any file before editing it. Auto-compaction
  may have replaced your detailed memory of its contents with a summary.
- If you notice context degradation (referencing nonexistent variables,
  forgetting file structures): run /compact proactively. Write session
  state to context-log.md so forks can pick up cleanly.
- File reads are capped at a default line limit. For files over 500 LOC:
  use offset and limit to read in chunks. Plan for chunked reads
  proactively.
- Tool results over a threshold get truncated, with the full output
  written to a path. If results look suspiciously small or end mid-data:
  read the full file at the given path, or re-run with narrower scope.

---

## Edit Safety

- Before every file edit: re-read the file. After editing: read it again
  to verify the change landed where you expected.
- The Edit tool errors loudly when old_string doesn't match or isn't
  unique. The harder-to-catch failure is matching the *wrong location*
  because your in-context view of the file is stale, or because the
  string appears in a place you didn't anticipate. Re-reading is the only
  defense.
- You have grep, not an AST. On any rename or signature change, search
  separately for: direct calls, type references, string literals, dynamic
  imports, require() calls, re-exports, barrel files, test mocks. Start
  with barrel files and re-exports - they're the most commonly missed.
  Assume grep missed something even after all of these.
- Never delete a file without verifying nothing references it.

---

## Self-Correction

- After any correction: log the pattern to gotchas.md. Convert mistakes
  into rules. Review past lessons at session start.
- If a fix doesn't work after two attempts: stop. Read the entire relevant
  section top-down. State where your mental model was wrong.

---

## Communication

- Work from raw error data. Don't guess. If a bug report has no output,
  ask for it before doing anything.
- When I say "yes", "do it", or "push": execute. Don't repeat the plan.
- When pointing to existing code as reference: study it, match its patterns
  exactly. My working code is a better spec than my description.
