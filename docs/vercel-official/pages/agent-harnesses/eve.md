---
title: Running eve Agents Durably on Vercel
product: vercel
url: /docs/agent-harnesses/eve
canonical_url: "https://vercel.com/docs/agent-harnesses/eve"
last_updated: 2018-10-20
type: how-to
prerequisites:
  - /docs/agent-harnesses
related:
  - /docs/eve
  - /docs/agent-harnesses
summary: eve agents are durable out of the box on Vercel, with no extra configuration.
install_vercel_plugin: npx plugins add vercel/vercel-plugin
---

# Running eve Agents Durably on Vercel

[eve](/docs/eve) is Vercel's framework for durable AI agents. Every eve session already runs as a durable workflow on the [Workflow SDK](https://workflow-sdk.dev) and its Worlds, the same foundation as the other harnesses in these guides. A crash, a function timeout, or a redeploy resumes the session from its last completed step.

There's nothing to add: you don't install `durable-harness`, write a flow route, or configure a queue. To learn how durability works, see [Running Agent Harnesses Durably](/docs/agent-harnesses).

## Get started

- ### Create an agent
  The eve CLI scaffolds a new agent project, installs its dependencies, and starts the development server:
  ```bash
  npx eve@latest init my-agent
  ```
  To add eve to an existing app, follow the [eve quickstart](https://eve.dev/docs/getting-started#install-manually).

- ### Deploy
  From the new project:
  ```bash
  cd my-agent
  vercel deploy
  ```

For agents, tools, channels, and everything else, see the [eve documentation](https://eve.dev/docs) and [eve on Vercel](/docs/eve).


---

[View full sitemap](/docs/sitemap)
