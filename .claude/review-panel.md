# Review Panel Config -- vercel-tools

Consumed by the `review-panel:reviewers` plugin skill (`review-panel@mayurahq`).
Process lives in the plugin; judgment lives here. The engine reads this file at
Step 0 of every run and applies the values below verbatim. Contract:
agent-os `plugins/review-panel/README.md`.

Run `/review-panel:reviewers` (auto-selects reviewers from the changed files) or
`/review-panel:reviewers code` (code-only pass).

## Constants

| Key | Value |
|-----|-------|
| `output_dir` | `.claude/reviews/` -- working record; gitignore it, or commit it if you want an audit trail |
| `deferred_ledger` | `docs/tasks/planning/000-deferred.md` -- created on first use |
| `task_dirs` | `docs/tasks/backlog/`, `docs/tasks/planning/` -- search here for an existing task before creating a new one |
| `context_files` | `AGENTS.md`, `CLAUDE.md`, `docs/AGENTS.md`, `docs/tasks/AGENTS.md` |
| `pr_comment` | `on` -- verdict table posted to the open PR; closing line reads "Merge pending PR approval" |
| `learnings` | `on` -- after triage, the panel-learnings agent proposes learnings: edits to the repo file that owns the rule, or an agent-os issue; each needs approval |

## Roster

Each `Agent` resolves repo-local first (`.claude/agents/<name>.md`), then
plugin-scoped. Add a row for every repo-local reviewer you add, or the engine
reports it as drift.

| Agent | Advocate for | Skip when | Launch focus |
|-------|--------------|-----------|--------------|
| `review-panel:reviewer-security` | Injection, secrets, access control, supply chain | Docs-only change | Check trust boundaries for injection, hardcoded credentials, authorization gaps on new entry points, and dependency/CI changes that widen the trust boundary. |
| `review-panel:reviewer-test` | Coverage gaps, weak assertions | No test-bearing source files changed | Identify untested paths (especially error branches), weak assertions, and non-hermetic or brittle tests on the changed code. |
| `review-panel:reviewer-dx` | Over-engineering, YAGNI, naming, pattern drift | Single typo fix only | Flag over-engineering, YAGNI violations, unclear naming, divergent patterns, and unnecessary abstraction. Philosophy: reliable MVP -- secure, scalable, maintainable, flexible -- not over-engineered. |
| `review-panel:reviewer-docs` | Doc freshness, onboarding | Single typo fix, or the `code` flag is set | Check `README.md`, `AGENTS.md`, `CLAUDE.md`, and `docs/` against the change: stale statements, undocumented config or interfaces, onboarding gaps. |

## Flags

- `code` → skip `review-panel:reviewer-docs`; append to every surviving reviewer's launch prompt: "Code-only pass -- documentation changes are out of scope; focus on correctness, security, and quality."
- Only `code` is defined here. Any other bare argument is taken as the run slug, not a flag (engine behavior).

## Hard Triage Rules

These override cost/scope reasoning in the fix loop -- value decides the bucket,
cost only decides how. Replace these with this repo's own invariants as they
become clear.

- **Exposed credential or secret → always Fix.** A key, token, or password reachable from the repo or its build output is never deferrable, however small the diff.
- **Untrusted input reaching an exec, query, or file path unvalidated → always Fix.** Injection at a trust boundary is a correctness defect, not a hardening suggestion.
- **Agent model-tier violation → always Fix.** Any `.claude/agents/*.md` with `model: inherit`, missing, or unrecognized silently runs on the session model. Canonical policy: agent-os `docs/model-selection.md`.
- **Broken build, CI, or manifest → always Fix.** A change that does not build, or that breaks the pipeline for everyone else, is never "pre-existing".

## Approval Gates

- **Attended mode.** Every triage table (fix-loop rounds and suggestion triage) needs explicit user approval before anything is persisted or committed -- no fix commit, task file, or deferral row until the user approves the table it appears in.
- **Push, PR, and merge each need their own explicit approval.** A panel run never performs them.
