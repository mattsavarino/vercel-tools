# Idea: Personal music school

- **Idea, in Matt's words**: "Use Vercel to allow the app to be privately
  available no matter where I'm located. Combine edge processing with Vercel
  cloud services, but to start, strategically inventory."
- **Source of goals**: the music repo's needs brief and architecture v3
  (`~/git/mattsavarino/music/docs/needs-brief.md`, `docs/architecture.md`,
  `docs/status.md`), read 2026-10-16. Read only; that repo owns its decisions.
- **Catalog**: service numbers below (`#N`) refer to `docs/vercel-services.md`.

## Goal, mission, value props

- **Mission**: more time playing well, less time in software. One musician,
  single user, private.
- **Value props** (from the needs brief, in its priority order):
  1. **Play now**: open a phone, get one concrete thing to play, no decisions.
  2. **Log it** in seconds, feeding progress.
  3. **Know what I'm working on**: ranked goals with now, next, start here.
  4. **Songs**: about 660, filterable, with a music-stand view.
  5. **Courses and lessons** from many sources, scored against goals.
  6. **Weekly plan and review**: a conversational recap proposed, then applied.
  7. **Inspiration** from listening history; 8. **Gear** (lowest).
- **Constraints**: Vercel Pro already owned; an always-on Mac Studio as the
  edge; cost-conscious; own the data; Python through uv; Claude subscription.

## Advisor view on the current plan

The music repo sequences local first (Studio, then a desk TRMNL), with a
"cloud gate" last. **I would flip that.** The stated reason for Vercel is
access from anywhere, and value prop 1 is "open a phone". A desk display
proves the card is right; only the cloud proves the card is reachable. The
daily loop is already built (phase 1) and about 21% of the source sits dormant
waiting for the cloud gate, so the MVP below is mostly turning on what exists.
The edge keeps its role: heavy, scheduled, and AI work stays on the Studio.

## MVP: Play now, from anywhere

Deploy the existing Next.js app to Vercel Pro with the database on Neon, and
put the whole deployment behind Vercel Authentication.

| Piece | Service | Why |
|---|---|---|
| App, API routes | #1 Functions, #2 Deployments | Existing Next.js app; preview per branch |
| Database | #11 Marketplace Storage (Neon) | Already the architecture's choice; one-command provisioning |
| Private access | #7 Deployment Protection (Vercel Authentication, All Deployments) | Free on all plans; a second lock in front of the app's own passkey sign-in |
| Basic shielding | #6 Firewall (DDoS, custom rules) | Free; nothing to configure for MVP |

- **Proved when**: from a phone away from home, the today card loads in under
  3 s cold, a log survives a dropped connection, and you use it daily for two
  weeks (the music repo's own bar).
- **Cost**: inside the Pro plan you already pay for. Hobby-sized usage
  (#1: 4 CPU-hrs, 1M invocations included) is far above one person's daily
  loop. Neon on its free plan (provider pricing, not in Vercel docs).
- **Before building**: the music repo's backup and restore drill, since the
  data now lives in the cloud.
- **Risk**: Vercel Authentication sessions on a phone PWA. If the login
  prompt interrupts "open and play", keep protection on previews only
  (Standard Protection) and rely on the app's passkey for production.

## Layer 1: Edge feeds the cloud

The Studio stays the worker: it fetches, scores, and pushes results up.

- **Adds**: fresh data on the phone without the Studio being reachable.
- **Services**: #1 Functions (`/api/ingest/<source>`), #7 Protection Bypass
  for Automation (included) so the Studio's pushes pass the gate, #6 WAF rate
  limiting on the ingest route ($0.50-$0.80 per 1M allowed requests; one
  person's nightly pushes cost effectively nothing).
- **Before building**: the MVP proved; the first connector (learn-guitar
  import) running from the Studio.

## Layer 2: Songs on the music stand

- **Adds**: value prop 4. A fast catalog and a stand view.
- **Services**: #3 CDN and ISR to cache song pages (watch the 8 KB write
  units: no timestamps in rendered output), #9 Blob only when PDF tabs or
  chart images are real (Hobby-sized 1 GB is plenty; deletes free), #5 Image
  Optimization for chart images (5K transformations included).
- **Before building**: the stand view in daily use from the MVP data.

## Layer 3: Light scheduling in the cloud

- **Adds**: jobs that should run even when the Studio is down.
- **Services**: #14 Cron Jobs (free; Pro allows precise schedules), #13
  Workflows for multi-step jobs such as assembling the weekly review packet
  (50,000 events/month on Hobby terms; $0.02 per 1K beyond).
- **Rule**: heavy and AI work stays on the Studio; cloud jobs only stitch
  together data that is already there.
- **Before building**: a job that actually failed because the Studio was off.

## Layer 4: Weekly review from the phone

- **Adds**: value prop 6 without opening a terminal. Talk through the week on
  the phone; the app returns one batched proposal you apply.
- **Services**: #18 AI Gateway (no token markup, budgets, one key for any
  model), #19 AI SDK for the chat and structured proposal output. Optional
  later: #20 eve, whose `caution` approval gate matches the music repo's
  "agents propose, the player applies" rule, once it leaves beta.
- **Cost**: model tokens at provider list price; a weekly recap is a handful
  of calls. Set a Gateway budget.
- **Before building**: the Claude Code `/wrap` recap has worked for a month,
  so the cloud version copies a proven flow.

## Layer 5: Agents see production

- **Adds**: Claude Code and Codex can read deployments and logs while
  developing.
- **Services**: #23 Vercel MCP (public beta), #24 Observability (free; logs
  kept 1 day on Pro), #25 Speed Insights (free) to track the under-3 s card.

## Deliberately not used

- **#15 Daemons, #12 Queues**: the Studio is already the always-on worker; no
  fan-out yet.
- **#16 Sandbox, #17 Drives, #21 Agent Harnesses**: nothing runs untrusted
  or agent-generated code.
- **#22 Connect**: third-party tokens (Spotify, TrueFire) stay on the Mac,
  per the music repo's sovereignty rule. Revisit if a cloud job needs one.
- **#8 Services, #10 Flags, #4 Middleware**: one app, one user, no
  experiments.

## Open questions

- Does Vercel Authentication on production fit a phone PWA with an offline
  service worker? Test in the MVP before committing to it.
- Neon free-plan cold starts against the 3 s target: the music repo plans a
  Studio keep-warm ping; a Cron Job (#14) could do the same from the cloud.
- Flip the sequencing (cloud first) or keep local first: the music repo's
  call; this plan recommends flipping.
