# Vercel Ship 2026 Notes

- **Event**: Vercel Ship 2026, livestreamed 2026-10-15
- **Stream**: https://www.youtube.com/watch?v=Fr5vzNknYJE (6:31:22)
- **Source**: Matt's notes from watching live. Transcript follow-up:
  `docs/tasks/planning/100-vercel-ship-2026-transcript.md`

## Notes

- Typescript + now Python
- Learning Loop: Telemetry => Optimizations => Evaluations

## Highlighted Tech
- Fluid
- Drives
- Daemons
- Eve

## Multi-Agent + now Multi-Player

## Multi-Agent Strategies
- Execute, of course.
- **Advise, Grade, Learn***
- various types (i.e. fan-out vs. adversarial)

## Anthropic's Vercel Setup
For security purposes, separate "brain" (thinking) from "hands" (actions).

- Front Door: ChatSDK / Next.js App
- Brain: Cloud Models / Harnesses / Session Store / Vault
- Hands (the untrusted layer): Sandbox => Firewall => Your Systems

## Follow-up

- [ ] Get the transcript(s): the stream had no captions on 2026-10-16. Check
      back around 2026-10-20 for captions or Vercel's per-session uploads.
      Tracked in `docs/tasks/planning/100-vercel-ship-2026-transcript.md`.

## Related docs

Mirrored pages under `docs/vercel-official/pages/`:

| Topic | Pages |
|-------|-------|
| Fluid | `fluid-compute.md` |
| Drives | `sandbox/concepts/drives.md` |
| Daemons | `daemons.md` |
| Eve | `eve.md` |
| Multi-agent, harnesses | `agent-harnesses.md`, `agent-harnesses/security.md`, `agent-resources.md` |
| Learning loop (telemetry, evals) | `observability.md`, `ai-gateway.md` |
| Brain/hands setup | `connect.md` (front door), `connect/frameworks/chat-sdk.md`, `connect/python-sdk-reference.md`, `sandbox.md`, `vercel-firewall.md`, `workflows.md` |
