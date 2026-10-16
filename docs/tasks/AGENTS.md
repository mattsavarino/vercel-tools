# AGENTS.md for vercel-tools tasks

Lightweight task system: what was done, what's next, what's deferred. These
rules bind every tool and every session that creates, edits, or closes a task.

## Layout

```
docs/tasks/
├── backlog/     # Committed, can start today; prefix = execution order
├── planning/    # Not ready: needs scoping, research, or a trigger
│   └── 000-deferred.md   # Deferred and rejected register; not a task
└── resolved/    # Done; numbered in completion order
```

**Status is the folder.** Task files carry no `Status:` field; a written status
only drifts from where the file sits.

## Naming

- `backlog/` and `planning/`: `NNN-slug.md`. Lower prefix runs first; leave gaps
  (`100`, `200`) so a task can be inserted without renaming others.
- `resolved/`: `NNN-slug.md` in completion order. Next number: glob
  `resolved/*.md`, take the highest numeric prefix, add one.
- **Refer to tasks by name, never by number.** Prefixes change on reorder.

## Before writing a task

- **Should, not could.** A task is work worth doing, not an idea. Ideas that
  have not earned that bar get a row in `planning/000-deferred.md` instead.
- **Search first.** Check `backlog/`, `planning/`, and `resolved/` for an owner
  before creating a file. Absorbing into an existing task beats a new one.
- **One task, one concern.** Split compound work into separate files.
- **Validate before planning.** Read the code a task touches before planning
  it; never assume a task file still matches the repo.

## Placement

- A task sits in `backlog/` only when it can start today. One blocked on another
  task stays in `backlog/` only when that blocker is also in `backlog/` ahead of
  it; one blocked on an outside trigger or unfinished research goes to
  `planning/`. Name the blocker under **Dependencies**.
- **A yes/no is never a task.** If all that remains is a decision, ask it now and
  close or fold the file.
- **Rollover, never silent loss.** A slipped date is extended or marked
  OVERDUE, never dropped.

## Closing

- **Finish beats file.** A session working the backlog finishes tasks; opening
  new ones is the last resort.
- **Close in the same change.** The change that delivers a task's last success
  criterion also checks the criteria, moves the file, and condenses it, before
  the PR opens, even when the change belongs to a different effort.
- **Move, then condense; never delete and recreate.** `git mv
  backlog/NNN-slug.md resolved/MMM-slug.md`, then compress it with the resolved
  template below: keep decisions, learnings, pointers, and deferrals; drop code,
  procedures, and narrative.
- **Reject, never silently delete.** A task dropped as no longer worth doing
  leaves through a row under `## Rejected` in `planning/000-deferred.md` (name,
  date, one-line reason, removing commit), written only after any context worth
  keeping has another home.

## Review findings

Route each finding once, to one home: fix now, a task file, a row in
`planning/000-deferred.md`, or nothing. A finding with a task file never also
gets a deferred row; when a deferred row gets a home, delete the row.

## Templates

**Open task** (`backlog/` and `planning/`)

```markdown
# Task: Name

**Dependencies**: task names, or None

## Why This Matters
The problem with evidence, who or what it serves, and the cost of not doing it.
A Why that restates the title fails.

## Success Criteria
- [ ] Concrete, verifiable outcome

## Approach
High-level plan. Pointers to code (`path:line` or a symbol), never pasted code.

## Out of Scope
- Item (reason)
```

**Resolved task** (`resolved/`)

```markdown
# Task: Name

**Resolved**: YYYY-MM-DD

## What Was Done
Two or three sentences, with pointers to the code.

## Key Decisions
- Decision, and why over the alternative

## Deferred
- What was explicitly not done, and where it now lives
```
