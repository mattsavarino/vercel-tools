# Vercel Ship 2026 Notes

- **Event**: Vercel Ship 2026, livestreamed 2026-10-15
- **Stream**: https://www.youtube.com/watch?v=Fr5vzNknYJE (6:31:22)
- **Source**: Matt's notes from watching live.
- **Transcript**: `transcripts/livestream-0000-0140.md` (0:00 to 1:40:00,
  YouTube auto-captions, uncorrected; verify names before quoting)

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
