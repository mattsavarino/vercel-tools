# Vercel Ship 2026 Notes

- **Event**: Vercel Ship 2026, livestreamed 2026-10-15
- **Stream**: https://www.youtube.com/watch?v=Fr5vzNknYJE (6:31:22)
- **Source**: Matt's notes from watching live. Indented "Stage:" lines were
  added 2026-10-19 from the transcript; `[H:MM:SS]` points into it.
- **Transcript**: `transcripts/livestream-0000-0140.md` (0:00 to 1:40:00,
  YouTube auto-captions, uncorrected; verify names before quoting)

## Notes

- Typescript + now Python
  - Stage [0:10:21]: Python GA. Standard CPython, deps via uv and
    `pyproject.toml`; Django, FastAPI, Flask run unchanged. Python and TS
    share Workflows and Queues [0:11:24]. Containers from a Dockerfile run on
    Fluid [0:12:25] (no status stated).
- Learning Loop: Telemetry => Optimizations => Evaluations
  - Stage [0:04:13, 0:06:15]: "production context is what turns software into
    a loop": agents watch traffic, traces, and anomalies, investigate, and
    open PRs. The exact phrase is not in 0:00 to 1:40:00; likely a later
    session.

## Highlighted Tech
- Fluid
  - Stage [0:13:25]: Vercel's own control plane runs 25+ microservices on it.
- Drives
  - Stage [0:24:37]: GA.
- Daemons
  - Stage [0:14:28]: public beta; target is always-on workers (Celery,
    Dramatiq, Temporal).
- Eve
  - Stage [0:17:33]: new persistent memory, extensions, and dashboard deploy.
    No beta or GA label stated.

## Multi-Agent + now Multi-Player
- Stage: multi-player is not discussed in 0:00 to 1:40:00.

## Multi-Agent Strategies
- Execute, of course.
- **Advise, Grade, Learn***
  - Stage [1:25:02], theme "tokens should have jobs":
    - **Advise**: a smaller executor model consults a larger one only for
      hard questions.
    - **Grade**: a rubric is defined up front; a separate grader agent checks
      the work and sends it back to iterate.
    - **Learn**, called "dreaming": after many sessions, aggregate learnings
      are written to memory.
  - Stage [1:27:02]: at constant budget, every strategy beat pure execution.
- various types (i.e. fan-out vs. adversarial)
  - Stage [1:30:08]: Claude's dynamic workflows (fan out and resynthesize,
    adversarial verification, loop until done). 66 of 70 bugs found per run
    versus 14 to 27 for a single agent [1:29:05]. Up to 1,000 agents and very
    token-hungry; set a session budget [1:31:09]. Vercel Workflows sit a
    layer up as deterministic code around the agent [1:28:04].

## Anthropic's Vercel Setup
For security purposes, separate "brain" (thinking) from "hands" (actions).

- Front Door: ChatSDK / Next.js App
- Brain: Cloud Models / Harnesses / Session Store / Vault
  - Stage [1:23:01]: Managed Agents, model, harness, session store, on a
    durable server. "Vault" is not said in this span; credentials are
    brokered at the sandbox firewall instead (below).
- Hands (the untrusted layer): Sandbox => Firewall => Your Systems
  - Stage [1:24:02 to 1:37:17]:
    - A Function boots a sandbox on webhook; the sandbox pulls jobs from a
      queue over outbound HTTPS only. Sandboxes are "cattle, not pets".
    - The sandbox holds placeholder tokens; the firewall injects real
      credentials on egress ("credentials brokering") [1:35:14].
    - Egress deny by default, else an allow list [1:37:17].
    - Monitoring and the kill switch live outside the sandbox [1:34:12].
    - Firecracker microVMs over gVisor [1:36:15].
  - Why the split [1:21:58]: a sandbox per request was unreliable (sandbox
    dies, agent dies), slow to boot, and put credentials next to untrusted
    code.

## Agent-readable sites (Aura talk)
- Stage [1:00:27]: agent traffic up almost 8,000%, now above human traffic.
- Cheap fixes, in order [1:15:51]: link `llms.txt` from home and docs; put
  content high in the HTML; keep markdown twins of key pages; do not block
  agents; offer tools (WebMCP).
- Agents guess URLs first in 35% of cases; top guesses `/pricing`, `/docs`,
  `/api` [1:07:39]. Screenshots cost 45x more tokens [1:06:38].

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
| Brain/hands setup | `connect.md` (front door), `connect/frameworks/chat-sdk.md`, `connect/python-sdk-reference.md`, `sandbox.md`, `sandbox/concepts/firewall.md`, `vercel-firewall.md`, `workflows.md` |
