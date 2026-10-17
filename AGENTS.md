# AGENTS.md for vercel-tools

Cross-tool repository guidance lives here. Put directory-specific guidance in
the closest `AGENTS.md`.

This repo is our Vercel toolkit: context, scripts, tools, docs, and AI agents
for getting the most out of Vercel.

- Stack: Unspecified (informational; verify project config)
- Official Vercel docs, mirrored locally: `docs/vercel-official/AGENTS.md`
- Vercel Ship 2026 notes: `docs/vercel-ship-2026/notes.md`
- Vercel services catalog (25 services, graded, with costs): `docs/vercel-services.md`
- Idea plans (MVP plus layers, matched to the catalog): `docs/ideas/`
- Scripts: `scripts/` (`sync-vercel-docs.sh` refreshes the docs mirror)
- Task rules and workflow: `docs/tasks/AGENTS.md`
- Review panel conventions: `docs/AGENTS.md`
- Claude-native mechanics: `CLAUDE.md` and `.claude/`
- Codex-native mechanics: `.codex/`

Keep instruction files complementary. One rule, one owner; use pointers instead
of copies.
