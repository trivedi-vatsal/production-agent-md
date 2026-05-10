# production-agent-md

My personal `CLAUDE.md` for Claude Code, packaged so the same operating
manual also works in Codex. `CLAUDE.md` is the source of truth.
`AGENTS.md` is a checked-in mirror for Codex compatibility.

This repo is opinionated on how agents should behave in production
codebases: planning, context management, edit safety, testing, and
self-correction.

- Claude Code reads `CLAUDE.md`
- Codex reads `AGENTS.md`
- `CLAUDE.md` stays canonical
- `AGENTS.md` is regenerated from `CLAUDE.md`

---

## Install

**Claude Code personal scope** (all projects on your machine):

```bash
curl -fsSL https://raw.githubusercontent.com/trivedi-vatsal/production-agent-md/main/install.sh | bash
```

This installs `CLAUDE.md` to `~/.claude/CLAUDE.md`.

**Project scope for Claude Code + Codex**:

```bash
curl -fsSL https://raw.githubusercontent.com/trivedi-vatsal/production-agent-md/main/install.sh | bash -s -- project
```

This installs:

- `./CLAUDE.md`
- `./AGENTS.md`
- `./gotchas.md` if missing
- `./context-log.md` if missing

The project install uses the canonical `CLAUDE.md`, mirrors it to
`AGENTS.md`, and seeds starter session-artifact files from `templates/`.
Existing files are backed up to `*.backup.<timestamp>` before overwrite.
Starter artifact files are only created when absent, so project history
is not clobbered.

---

## Manual install

For Claude Code personal scope:

```bash
mkdir -p ~/.claude
curl -fsSL https://raw.githubusercontent.com/trivedi-vatsal/production-agent-md/main/CLAUDE.md \
  -o ~/.claude/CLAUDE.md
```

For a project that should work in both Claude Code and Codex:

```bash
curl -fsSL https://raw.githubusercontent.com/trivedi-vatsal/production-agent-md/main/CLAUDE.md \
  -o ./CLAUDE.md
cp ./CLAUDE.md ./AGENTS.md
curl -fsSL https://raw.githubusercontent.com/trivedi-vatsal/production-agent-md/main/templates/gotchas.md \
  -o ./gotchas.md
curl -fsSL https://raw.githubusercontent.com/trivedi-vatsal/production-agent-md/main/templates/context-log.md \
  -o ./context-log.md
```

Or clone the repo and copy what you want:

```bash
git clone https://github.com/trivedi-vatsal/production-agent-md.git
cp production-agent-md/CLAUDE.md ~/.claude/CLAUDE.md
cp production-agent-md/CLAUDE.md ./AGENTS.md
cp production-agent-md/templates/gotchas.md ./gotchas.md
cp production-agent-md/templates/context-log.md ./context-log.md
```

---

## Repo layout

```text
production-agent-md/
- CLAUDE.md
- AGENTS.md
- install.sh
- scripts/
  - sync-agents.sh
- templates/
  - gotchas.md
  - context-log.md
- README.md
- LICENSE
```

---

## How I use it

- I edit `CLAUDE.md`
- I mirror it to `AGENTS.md`
- I copy the starter templates into project root when a repo needs
  persistent session memory

To refresh the Codex mirror after changing `CLAUDE.md`:

```bash
./scripts/sync-agents.sh
```

---

## What's in CLAUDE.md

| Section | Covers |
|---|---|
| Session Artifacts | `gotchas.md` and `context-log.md` conventions |
| Planning | Plan-first discipline, <=3 clarifying questions, mid-task ambiguity |
| Code Quality | Senior-review heuristic, no robotic comments |
| Testing | Run existing tests, flag missing coverage, new-user verification |
| Context Management | Sub-agent fan-out, re-read after compaction, chunked reads |
| Edit Safety | Re-read before and after edits, exhaustive grep checklist |
| Self-Correction | Log to `gotchas.md`, two-attempt rule |
| Communication | Raw error data, execute on "do it", match working code |

---

## Templates

`templates/gotchas.md` and `templates/context-log.md` are starter shapes
for the project-scoped working files referenced by the directives.

Use them like this:

```bash
cp templates/gotchas.md ./gotchas.md
cp templates/context-log.md ./context-log.md
```

Keep the working copies in the target repo root. The `templates/` versions
here are just reusable seeds.

---

## Customizing

Fork the repo, edit `CLAUDE.md`, run `./scripts/sync-agents.sh`, and point
install commands at your fork.

Good starting knobs to tweak:

- File-size thresholds (`>300 LOC`, `>500 LOC`)
- Phase size (`max 5 files`)
- Sub-agent fan-out (`5-8 files per agent`)

If you're publishing your own fork, replace `trivedi-vatsal` in the
commands above with your GitHub username.

---

## License

MIT. See `LICENSE`.
