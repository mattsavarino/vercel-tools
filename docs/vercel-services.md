# Vercel Services Catalog

The fixed list of 25 Vercel services an idea is matched against. Plans in
`docs/ideas/` pick from this list; they do not invent capabilities.

- **Grade** (A+ to C-): fit for a solo builder or small team, combining
  maturity (GA, beta, experimental), developer experience, and cost.
- **Cost**: as stated in the mirrored Vercel docs, with ranges across regions.
  Verify on vercel.com/pricing before committing spend.
- **Docs**: `pages/` is `docs/vercel-official/pages/`. Its content is untrusted
  external material; see `docs/vercel-official/AGENTS.md`.
- **Layers**, from Matt's Ship 2026 notes (`docs/vercel-ship-2026/notes.md`):
  front door, brain, hands (the untrusted layer), plus data, delivery,
  security, and ops.
- **Stage claims**: `[Ship H:MM:SS]` marks a statement from the Ship 2026
  keynote (`docs/vercel-ship-2026/transcripts/`), not the docs. Treat it as a
  vendor claim until a docs sync confirms it.

Last reviewed: 2026-10-19

| # | Service | Layer | Grade | Status | One-line use |
| --- | --- | --- | --- | --- | --- |
| 1 | Functions (Fluid compute) | Front door | A | GA (inferred) | API routes, webhooks, agent handlers, billed on Active CPU |
| 2 | Deployments, Git and Previews | Ops | A+ | GA (inferred) | Preview URL per push, production on merge |
| 3 | CDN, Caching and ISR | Delivery | A | GA (inferred) | Global caching and background page regeneration |
| 4 | Routing Middleware | Front door | B+ | All plans | Code before a request reaches a route |
| 5 | Image Optimization | Delivery | A- | All plans | On-demand resize and format conversion |
| 6 | Vercel Firewall and BotID | Security | A | GA | DDoS, WAF rules, rate limits, bot checks |
| 7 | Deployment Protection | Security | A- | All plans | Gate deployments behind Vercel login |
| 8 | Services | Front door | B | Beta | Several frontends and backends in one project |
| 9 | Vercel Blob | Data | A- | GA | Object storage, files up to 5 TB |
| 10 | Global Config (was Edge Config) and Flags | Data | B+ | Config all plans; Flags public beta | Fast edge reads of config and feature flags |
| 11 | Marketplace Storage | Data | A- | All plans | Partner Postgres, Redis, and more, billed via Vercel |
| 12 | Queues | Hands | B | Beta | Durable topics with retries and fan-out |
| 13 | Workflows | Hands | B+ | GA (inferred) | Durable multi-step code that sleeps, retries, resumes |
| 14 | Cron Jobs | Hands | A- | GA | Scheduled function invocations |
| 15 | Daemons | Hands | C+ | Public beta | Long-running container workers, no inbound traffic |
| 16 | Vercel Sandbox | Hands | A- | GA | Isolated microVMs for untrusted or agent code |
| 17 | Drives | Data | B+ | GA (changelog; Ship 2026) | Persistent storage mounted into sandboxes |
| 18 | AI Gateway | Brain | A | GA | One endpoint for many model providers, no token markup |
| 19 | AI SDK | Brain | A | Open-source library | TypeScript API for models, tools, streaming, agents |
| 20 | eve | Brain | B- | Beta | Filesystem-first framework for durable backend agents |
| 21 | Agent Harnesses (durable-harness) | Brain | C+ | Claude Code, Codex experimental | Crash-proof sessions for existing agent harnesses |
| 22 | Vercel Connect (incl. Chat SDK) | Brain | B+ | GA | Short-lived third-party tokens, no secrets in env vars |
| 23 | Vercel MCP and agent resources | Ops | B+ | Public beta | Coding agents read docs, deployments, and logs |
| 24 | Observability (logs, tracing, drains) | Ops | B+ | All plans; tracing beta | Logs, traces, metrics, export to external tools |
| 25 | Web Analytics and Speed Insights | Ops | A- | GA (Analytics) | Cookie-free traffic stats and real-user performance |

### 1. Functions (Fluid compute) -- A
- **What**: Server code for API routes, webhooks, and agent handlers; many requests share one instance, and CPU bills only while code runs.
- **+** Active CPU billing pauses during I/O waits (database, model calls), which suits AI workloads.
- **-** Max duration 300s on Hobby, 800s on Pro (30 min in beta); truly long jobs belong in Workflows, Sandbox, or Daemons.
- **Cost**: Hobby includes 4 hrs Active CPU, 360 GB-hrs Provisioned Memory, 1M invocations. Pro on demand: Active CPU $0.128-$0.221/hr, memory $0.0106-$0.0183/GB-hr, invocations $0.60 per 1M.
- **Status**: GA (inferred); 1800s extended duration is beta. Python GA and
  Dockerfile containers on Fluid announced [Ship 0:10:21, 0:12:25]; container
  status not stated.
- **Docs**: `pages/functions.md`, `pages/fluid-compute.md`, `pages/functions/usage-and-pricing.md`

### 2. Deployments, Git and Previews -- A+
- **What**: Every branch push builds a deployment with its own preview URL; merging to the production branch ships it.
- **+** Zero-config preview per PR is the core DX advantage; CDN and routing changes are previewable too.
- **-** Hobby is non-commercial only and cannot deploy private repos owned by a GitHub org, GitLab group, or Bitbucket workspace.
- **Cost**: Hobby includes Basic build machines. Paid: Basic $0.007 per build minute, other build usage $0.0035 per CPU minute. 100 deployments/day on Hobby, 6,000 on Pro. Extra paid seats $20/month.
- **Status**: GA (inferred).
- **Docs**: `pages/deployments.md`, `pages/git.md`, `pages/pricing.md`, `pages/limits.md`

### 3. CDN, Caching and ISR -- A
- **What**: Global CDN (126 PoPs) handling routing, caching, and compression; ISR serves cached pages while regenerating in the background.
- **+** Flat Rate CDN gives Pro a fixed-price tier; short spikes do not move the bill.
- **-** ISR reads and writes meter in 8 KB units, so non-deterministic output (`new Date()`) quietly runs up write charges.
- **Cost**: Hobby includes 100 GB Fast Data Transfer, 1M CDN requests, 10 GB Fast Origin Transfer. Pro includes 1M requests and 1 TB via Flat Rate CDN; tiers $20/mo (10M, 50 TB), $100/mo (50M), $300/mo (150M). On demand: FDT $0.15-$0.35/GB, requests $2.00-$3.20/1M, FOT $0.06-$0.43/GB, ISR writes $4.00-$6.40/1M units, ISR reads $0.40-$0.64/1M units.
- **Status**: GA (inferred); ISR on all plans.
- **Docs**: `pages/cdn.md`, `pages/caching.md`, `pages/incremental-static-regeneration/limits-and-pricing.md`, `pages/pricing/flat-rate-cdn.md`

### 4. Routing Middleware -- B+
- **What**: Code that runs before a request is processed: rewrites, redirects, auth checks, personalization (Node.js or Bun).
- **+** Gates or personalizes at the routing layer without touching each route.
- **-** Billed as Fluid compute on every matched request; static `vercel.json` redirects or Global Config are cheaper for simple cases (inferred).
- **Cost**: Fluid compute rates (see 1); no separate included amount stated.
- **Status**: All plans.
- **Docs**: `pages/routing-middleware.md`

### 5. Image Optimization -- A-
- **What**: On-demand resize and WebP/AVIF conversion with a global cache.
- **+** Billing follows images actually served (transformations on cache miss), not images in the project.
- **-** On Hobby, new images return 402 once over the limit; only JPEG, PNG, WebP, and AVIF sources are optimized.
- **Cost**: Hobby includes 5K transformations, 300K cache reads, 100K cache writes per month. On demand: $0.05-$0.0812 per 1K transformations, $0.40-$0.64 per 1M cache reads, $4.00-$6.40 per 1M cache writes.
- **Status**: All plans.
- **Docs**: `pages/image-optimization.md`, `pages/image-optimization/limits-and-pricing.md`

### 6. Vercel Firewall and BotID -- A
- **What**: Platform DDoS mitigation, a WAF (custom rules, IP blocking, managed rulesets, Attack Mode, rate limiting), and invisible bot detection (BotID).
- **+** Denied, challenged, or rate-limited traffic incurs no CDN request or transfer charges; DDoS mitigation is free and automatic.
- **-** OWASP managed rules and BotID Deep Analysis meter per request, which adds up at high traffic.
- **Cost**: DDoS, IP blocking, custom rules free on all plans. Rate limiting $0.50-$0.80 per 1M allowed requests. OWASP CRS $0.80-$1.28 per 1M inspected plus $0.20-$0.32/GB. BotID Basic free; Deep Analysis on Pro $1 per 1,000 checks.
- **Status**: GA (rate limiting and BotID per changelog).
- **Docs**: `pages/vercel-firewall.md`, `pages/vercel-firewall/vercel-waf/usage-and-pricing.md`, `pages/botid.md`

### 7. Deployment Protection -- A-
- **What**: Controls who can open preview and production URLs (Vercel Authentication, Password Protection, Trusted IPs, Passport), with automation bypasses.
- **+** Vercel Authentication and Standard Protection are free on every plan and on by default for new projects.
- **-** Passport, Trusted IPs, and production-only protection need Enterprise; Password Protection is not on Hobby.
- **Cost**: Vercel Authentication, Standard Protection, All Deployments, and bypasses included on all plans. Password Protection $20/month per protected project on Pro. Passport custom (Enterprise).
- **Status**: All plans; Passport Enterprise-only.
- **Docs**: `pages/deployment-protection.md`, `pages/deployment-protection/usage-and-pricing.md`, `pages/passport.md`

### 8. Services -- B
- **What**: Several frontends and backends (for example Next.js plus FastAPI) in one project, with shared routing, env, domain, and private service bindings.
- **+** No need to split a monorepo into several projects; service-to-service calls carry no CDN or transfer charge.
- **-** Beta, replacing the older `experimentalServices` config; expect churn.
- **Cost**: Compute billed as Functions (see 1). Service Requests: Hobby first 1M, on demand $0.50-$0.80 per 1M; response bytes billed as Fast Origin Transfer.
- **Status**: Beta.
- **Docs**: `pages/services.md`, `pages/services/pricing.md`

### 9. Vercel Blob -- A-
- **What**: Private or public object storage, files up to 5 TB, served through the CDN.
- **+** Client uploads skip transfer charges, and Blob transfer is about 3x cheaper than FDT on average.
- **-** Hobby is a hard stop (unavailable for 30 days over the limit); blobs over 512 MB are never cached. S3 or R2 for large archives (inferred).
- **Cost**: Hobby includes 1 GB storage, 10,000 simple ops, 2,000 advanced ops, 10 GB transfer. On demand: storage $0.023-$0.041/GB, simple ops $0.35-$0.56/1M, advanced ops $4.50-$7.00/1M, transfer $0.05-$0.117/GB (covered by Flat Rate CDN on Pro). Deletes free.
- **Status**: GA.
- **Docs**: `pages/vercel-blob.md`, `pages/vercel-blob/usage-and-pricing.md`

### 10. Global Config (was Edge Config) and Flags -- B+
- **What**: A small global key-value store read near the user (flags, redirects, IP blocks), plus Vercel Flags for targeting, segments, and Flags Explorer.
- **+** Config reads need no database round trip.
- **-** Stores max out at 1 MB with up to 10s write propagation; Vercel Flags is public beta (LaunchDarkly or Statsig via Marketplace are mature).
- **Cost**: Global Config: Hobby first 100,000 reads and 100 writes; on demand $3 per 1M reads, $1 per 100 writes. Flags: Hobby 10,000 requests; Pro $0.03 per 1,000. Flags Explorer $250/month on Pro.
- **Status**: Global Config all plans; Flags public beta.
- **Docs**: `pages/global-config.md`, `pages/global-config/global-config-limits.md`, `pages/flags/vercel-flags/limits-and-pricing.md`

### 11. Marketplace Storage -- A-
- **What**: Partner databases (Neon, Supabase, AWS Aurora Postgres, Redis, Upstash) provisioned from the dashboard or `vercel install`, credentials injected as env vars.
- **+** One command provisions and connects; billing is unified through Vercel.
- **-** Each database is a third-party product with its own limits, pricing, and support (inferred).
- **Cost**: Set by each provider's plan; not in Vercel docs.
- **Status**: All plans.
- **Docs**: `pages/marketplace-storage.md`, `pages/storage.md`

### 12. Queues -- B
- **What**: Durable append-only topics with consumer groups, retries, delays, idempotency keys, push or poll.
- **+** The same primitive behind Workflows and durable-harness; works on preview deployments.
- **-** Beta; max retention 7 days, max visibility timeout 60 minutes. Use Workflows for multi-step logic.
- **Cost**: Hobby first 1M operations. On demand $0.60-$0.96 per 1M, metered in 4 KiB chunks; idempotent sends and concurrency-capped pushes count 2x.
- **Status**: Beta.
- **Docs**: `pages/queues.md`, `pages/queues/pricing.md`

### 13. Workflows -- B+
- **What**: Durable functions (`'use workflow'`, `'use step'`) that retry, sleep for minutes or months, wait on hooks, and resume across crashes and deploys; JS, TS, and Python.
- **+** Plain async code instead of YAML or state machines, with no maximum run duration.
- **-** Some features beta or experimental; run state kept only 1 day on Hobby, 7 days on Pro.
- **Cost**: Hobby includes 50,000 events/month and 1 GB written. On demand $0.02 per 1K events, $0.50/GB written, $0.50/GB-month retained (not on Hobby).
- **Status**: GA (inferred; not labeled).
- **Docs**: `pages/workflows.md`, `pages/workflows/pricing.md`

### 14. Cron Jobs -- A-
- **What**: Scheduled invocations of a Function, declared in `vercel.json`.
- **+** No extra charge on any plan; up to 100 per project.
- **-** Hobby runs at most once per day with plus or minus 59 minutes precision.
- **Cost**: Included; invocations billed as Functions (see 1).
- **Status**: GA.
- **Docs**: `pages/cron-jobs.md`, `pages/cron-jobs/usage-and-pricing.md`

### 15. Daemons -- C+
- **What**: Long-running container workers (queue consumers, job runners) built from a Dockerfile, run next to the app.
- **+** Brings Celery or BullMQ-style workers into the same project and rollout.
- **-** Public beta: production only, no inbound traffic, no autoscaling, no persistent disk. Railway or Fly.io are mature (inferred).
- **Cost**: Hobby 10 Active CPU-hrs/month; Pro quota 16 vCPUs and 32 GiB at once. Per-unit rates not in docs.
- **Status**: Public beta.
- **Docs**: `pages/daemons.md`, `pages/daemons/limits.md`

### 16. Vercel Sandbox -- A-
- **What**: Firecracker microVMs for untrusted or agent-generated code, with snapshots, persistence, custom images, and JS, Python, or CLI SDKs.
- **+** Active CPU billing skips time waiting on model inference; downloads into a sandbox are free.
- **-** Hobby sessions capped at 45 minutes (Pro 24 hours) with 10 concurrent sandboxes. E2B is the alternative (inferred).
- **Cost**: Hobby includes 5 CPU-hrs, 420 GB-hrs memory, 5,000 creations, 20 GB transfer, 15 GB snapshots. Pro (iad1): $0.128/hr Active CPU, $0.0212/GB-hr memory, $0.60 per 1M creations, snapshots $0.08/GB-month.
- **Status**: GA.
- **Docs**: `pages/sandbox.md`, `pages/sandbox/pricing.md`, `pages/sandbox/concepts/firewall.md`

### 17. Drives -- B+
- **What**: Persistent directories mounted into sandboxes (up to 4 per run) that keep workspaces and caches across runs, with read-only snapshots for sharing.
- **+** Persists until deleted, unlike sandbox snapshots (30-day TTL); `fork()` gives each fan-out agent its own copy.
- **-** Only usable mounted into a sandbox; Hobby drives default to 1 GiB.
- **Cost**: Hobby includes 15 GB storage plus 30 GB/month each of reads and writes. Pro (iad1): $0.05/GB-month, $0.0015/GB reads, $0.004/GB writes.
- **Status**: GA per the latest changelog and [Ship 0:24:37]; some mirrored pages still say beta.
- **Docs**: `pages/sandbox/concepts/drives.md`, `pages/sandbox/pricing.md`

### 18. AI Gateway -- A
- **What**: One endpoint for text, image, video, speech, and embeddings across providers, with budgets, logs, BYOK, and fallback.
- **+** No markup or platform fee on tokens, even with BYOK; works from any infrastructure.
- **-** The free tier covers a subset of models at lower rate limits; credit top-ups carry payment-processing fees.
- **Cost**: Provider list price from prepaid credits. Add-ons: Custom Reporting $0.075 per 1,000 writes and $5 per 1,000 queries; team allowlist or ZDR $0.10 per 1,000 requests; Trace Drains $0.05 per 1,000 traces plus $0.50/GB. Token Pass, early access: $30/month for $80 of open-model usage, ZDR on by default [Ship 0:21:34].
- **Status**: GA. Budgets per key, project, and team [Ship 0:20:34].
- **Docs**: `pages/ai-gateway.md`, `pages/ai-gateway/pricing.md`

### 19. AI SDK -- A
- **What**: TypeScript toolkit with one API for models, tools, structured output, streaming, and agents (`ToolLoopAgent`).
- **+** Provider-agnostic; pairs with AI Gateway through plain model strings.
- **-** TypeScript-first; some APIs ship as `experimental_*`, so pin versions (inferred).
- **Cost**: Open source; model costs via provider or AI Gateway.
- **Status**: Open-source library.
- **Docs**: `pages/ai-sdk.md`

### 20. eve -- B-
- **What**: Open-source, filesystem-first framework for durable backend agents (instructions, tools, skills, subagents) compiled onto Functions, Workflows, Sandbox, AI Gateway, and Connect.
- **+** Durable sessions out of the box, with tool approval gates and a sandbox per agent.
- **-** Beta, APIs may change, TypeScript only (Python support unconfirmed despite Python GA [Ship 0:10:21]); AI SDK plus Workflows is the stable alternative (inferred). Persistent memory, extensions, and dashboard deploy announced [Ship 0:17:33].
- **Cost**: No eve fee; billed through the services it consumes.
- **Status**: Beta.
- **Docs**: `pages/eve.md`, `pages/eve/concepts.md`, `pages/eve/pricing.md`

### 21. Agent Harnesses (durable-harness) -- C+
- **What**: Packages and guides that make Pi, fx, OpenCode, eve, Claude Code, and Codex sessions resume after crashes, timeouts, or redeploys.
- **+** Keeps an existing harness and adds a durable session log; the sandbox holds no secrets.
- **-** Claude Code and Codex support is experimental, in `vercel-labs`; start with eve if starting fresh.
- **Cost**: Not in docs (inferred: underlying Queues, Functions, Sandbox, AI Gateway).
- **Status**: Claude Code and Codex experimental.
- **Docs**: `pages/agent-harnesses.md`, `pages/agent-harnesses/security.md`

### 22. Vercel Connect (incl. Chat SDK) -- B+
- **What**: Connectors to Slack, GitHub, Microsoft, Snowflake, Salesforce, or any OAuth or API-key service; code requests short-lived tokens at call time, and Connect verifies and forwards webhooks. Chat SDK adapters authenticate through it.
- **+** No provider secrets in env vars; user-delegated tokens built in; Python SDK too.
- **-** $3 per 1,000 token requests on Pro is steep without SDK token caching (inferred).
- **Cost**: Hobby includes 500 token requests and 1,000 triggers per month. Pro $3.00 per 1,000 token requests, $0.95 per 1,000 triggers.
- **Status**: GA.
- **Docs**: `pages/connect.md`, `pages/connect/pricing.md`, `pages/connect/frameworks/chat-sdk.md`

### 23. Vercel MCP and agent resources -- B+
- **What**: Vercel's remote MCP server (OAuth), the Vercel plugin, agent skills, and markdown docs, so coding agents can search docs, manage deployments, and read logs.
- **+** A coding agent inspects real deployment state and logs without custom tooling.
- **-** Only Vercel-reviewed MCP clients connect; public beta.
- **Cost**: Not in docs.
- **Status**: Public beta.
- **Docs**: `pages/agent-resources.md`, `pages/agent-resources/vercel-mcp.md`, `pages/agent-resources/markdown-access.md`

### 24. Observability (logs, tracing, drains) -- B+
- **What**: Built-in insights for functions, CDN, middleware, ISR, Blob, AI Gateway, and Queues, plus runtime and build logs, OpenTelemetry tracing, and Drains.
- **+** Free on all plans, with JSON output agents can read.
- **-** Runtime logs kept 1 hour on Hobby and 1 day on Pro; Drains are Pro-only.
- **Cost**: Base free. Observability Plus $1.20 per 1M events (Pro). Drains $0.50/GB on Pro. Always-on tracing pricing not in docs.
- **Status**: All plans; always-on tracing beta.
- **Docs**: `pages/observability.md`, `pages/drains.md`, `pages/limits.md`

### 25. Web Analytics and Speed Insights -- A-
- **What**: Cookie-free page-view and event analytics, plus real-user Core Web Vitals.
- **+** Drop-in packages, unlimited projects; Speed Insights free on every plan.
- **-** Hobby has a 1-month window and no custom events. PostHog or Plausible go deeper (inferred).
- **Cost**: Web Analytics: Hobby 50,000 events/month; Pro $0.03 per 1K; Plus $10/month per team. Speed Insights: 10,000 events per rolling 30 days free; Plus $10/project/month plus $0.65 per 10,000 events.
- **Status**: Web Analytics GA.
- **Docs**: `pages/analytics/limits-and-pricing.md`, `pages/speed-insights/limits-and-pricing.md`

## Cost-efficient patterns

Architecture choices that buy the most impact per dollar, built only from the
services above. Plans in `docs/ideas/` should start here.

1. **CDN first, compute on demand** (#3, #1): static and ISR by default;
   Functions only where output truly varies per request. Flat Rate CDN on Pro
   makes delivery a fixed cost.
2. **Firewall in front of the bill** (#6): denied, challenged, or rate-limited
   traffic incurs no CDN or transfer charges. Rate-limit expensive routes;
   BotID Basic is free.
3. **Wait cheaply** (#1, #16): Active CPU billing pauses during I/O, so
   model, API, and database calls belong in Functions or Sandbox. CPU-heavy
   work (media processing, large transforms) does not (inferred).
4. **One durable background pattern** (#13, #14): Workflows plus Cron for all
   async and scheduled work, instead of Queues or Daemons plus hand-rolled
   retries. Cron is free; Workflows $0.02 per 1K events.
5. **Brain separate from hands** (#18, #19, #16, #22): AI SDK plus AI Gateway
   for thinking (no token markup, one budget, fallback); Sandbox for untrusted
   actions; Connect for short-lived tokens so agents hold no secrets.
   Anthropic's setup [Ship 1:21:58 to 1:37:17] adds: the harness on a durable
   server, throwaway sandboxes booted per job, placeholder tokens in the
   sandbox with real credentials injected by its firewall, egress deny by
   default, and monitoring plus the kill switch outside the sandbox.
6. **Client uploads to Blob** (#9): skip transfer charges on upload, and
   serve at roughly a third of the FDT price.
7. **Config at the edge** (#10): flags, redirects, and blocklists in Global
   Config, read without a database round trip, rather than Middleware (#4)
   doing a lookup on every request (inferred).
8. **Agents see production** (#23, #24, #18): Vercel MCP, logs, and Gateway
   logs give coding agents real deployment state, closing the telemetry,
   optimization, evaluation loop. Base is free; Drains $0.50/GB on Pro.

**Avoid for now**: #15 Daemons (beta, no published rates), #8 Services (beta),
#21 Agent Harnesses (experimental), Flags Explorer ($250/month).

### Cost checklist

Quiet bill drivers to check before a deploy goes live:

- [ ] ISR output is deterministic: no `new Date()` or random values (#3).
- [ ] Middleware matchers are narrow; simple redirects live in `vercel.json`
      or Global Config (#4, #10).
- [ ] Uploads go client-direct to Blob, not through a Function (#9).
- [ ] AI Gateway has a budget set (#18).
- [ ] Expensive or public write routes have a WAF rate limit (#6).
- [ ] Hobby hard stops are understood: Blob locks for 30 days and Image
      Optimization returns 402 once over the limit (#9, #5).
- [ ] Long jobs run in Workflows, not near the Function max duration (#1, #13).

## Not in the 25 (checked)

- **Passport, Sign in with Vercel**: Passport is Enterprise-only (see 7); Sign in with Vercel only helps users who have Vercel accounts.
- **Query**: Pro and Enterprise, folded into Observability Plus.
- **KMS**: beta, niche JWT signing.
- **Container Registry**: plumbing behind Daemons, Sandbox, and container Functions.
- **Vercel Agent**: public beta, Pro and Enterprise only.

## Known doc conflicts

Resolve against vercel.com before relying on these numbers.

- Pro function invocations: "N/A" in the pricing tables, $0.60 per 1M in prose (`pages/pricing.md`, `pages/functions/usage-and-pricing.md`).
- Pro included CDN requests: 1M in `pages/pricing/flat-rate-cdn.md`, 10M in the Blob pricing example.
- Drives status: private beta, public beta, and GA links on different pages; GA per changelog and Ship 2026.
- Function duration: Ship 2026 says Python requests run "up to 30 minutes" [Ship 0:10:21]; the docs list 800s on Pro and 1800s as beta.
- Hobby over-limit resets (Web Analytics, Sandbox) state two different rules on the same page.
- `pages/daemons.md` frontmatter shows `last_updated: 2018-10-20` (placeholder).

## Gaps

Pages to add to `docs/vercel-official/sources.txt` when a plan needs them:
`/docs/plans/hobby`, `/docs/plans/pro-plan`, `/docs/functions/limitations`,
`/docs/observability/observability-plus`, `/docs/tracing/always-on-tracing`,
`/docs/release-phases`, `/docs/workflows/concepts`.
