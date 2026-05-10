# Gotchas

Patterns from past mistakes. Review at session start.

Format: one entry per mistake. Keep it short - the rule matters more than
the story.

---

## YYYY-MM-DD - short title

**Mistake**: what went wrong, in one sentence.

**Rule**: the corrected behavior, phrased as a directive.

**Trigger**: when this pattern is likely to come up again (file types,
task shape, time of day, whatever).

---

<!-- Example:

## 2026-05-10 - barrel file rename miss

**Mistake**: renamed `UserService` and missed the re-export in
`src/services/index.ts`. Build broke.

**Rule**: on any rename, grep barrel files (`index.ts`, `index.js`)
before touching anything else.

**Trigger**: rename or signature change in any module that has siblings.

-->
