# AGENTS.md for vercel-tools docs

Detected stack: Unspecified (informational only -- verify against actual project config)

Task rules and workflow: `docs/tasks/AGENTS.md`.

## Review Panel

**Process lives in the plugin; judgment lives in this repo.** The orchestrator is the `review-panel:reviewers` plugin skill from `review-panel@mayurahq` -- run it with `/review-panel:reviewers` or by asking to "run the review panel." Nothing about the process is copied into this repo.

Everything repo-specific is in **`.claude/review-panel.md`**: the reviewer roster (with each reviewer's skip condition and launch focus), output paths, the deferred ledger, flags, hard triage rules, and approval gates. Edit that file to change who reviews what; the engine reads it at the start of every run. The config path is fixed -- do not rename it. Contract: agent-os `plugins/review-panel/README.md`.

**Reviewers come from plugins by default.** `review-panel@mayurahq` supplies the generic, language-agnostic reviewers (`review-panel:reviewer-security`, `review-panel:reviewer-test`, `review-panel:reviewer-dx`, `review-panel:reviewer-docs`); the language reviewer comes from the matching stack plugin (`python-stack:reviewer-python`, `rust-stack:rust-reviewer`, `typescript-stack:reviewer-typescript`). Nothing is copied into this repo for those.

Write a repo-local `.claude/agents/reviewer-*.md` only to **override** a plugin reviewer (a repo-local file of the same name always wins) or to **add** a lens no plugin covers (e.g. `reviewer-aws.md`, `reviewer-domain.md`). Repo-local reviewers are read-only (`tools: Read, Grep, Glob`) -- the engine persists their output. Add a roster row in `.claude/review-panel.md` for each; a reviewer file with no roster row is reported as drift.

Never keep a local `.claude/skills/reviewers/` -- a repo-local skill of that name shadows the plugin engine and will drift from it.

**Agent model tiers**: every agent in `.claude/agents/` pins an explicit model alias in frontmatter -- panel reviewers pin a judgment tier. Never use `model: inherit` without a stated reason in the agent file; it silently runs the agent on the session model, which on a premium session upgrades the whole panel to premium cost. Canonical policy: agent-os `docs/model-selection.md`. Right-size by cost per accepted result (a too-small tier that thrashes costs more than up-tiering) and set reasoning effort deliberately; cost discipline: agent-os `kb/cost-aware-agents.md`.

Deferred findings from review runs are tracked in `docs/tasks/planning/000-deferred.md` (created on first use).
