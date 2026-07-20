# AI Harness

An agnostic, reusable framework for **Specification-Driven Development (SDD)**.

## What it provides

- **Governance** — workflow, protocol, schemas, specification guidelines
- **Agents** — Orchestrator, Git Preflight, Spec Writer, Implementer, Reviewer

## What projects provide

- `knowledge/` — architecture and conventions
- `work/` — feature backlog and progress
- `specs/` — per-feature specifications
- Source code

## Quick start

1. Read [governance/AGENTS.md](governance/AGENTS.md) for the model overview
2. Follow [governance/deployment.md](governance/deployment.md) to adopt in a project
3. Install agent role cards into your agent host’s custom-agents directory
4. Open PROJECT_ROOT as the workspace and run: `Start Feature <slug>`
5. Orchestrator invokes Git Preflight, then Spec Writer on success

## Key documents

| Document | Purpose |
|----------|---------|
| [AGENTS.md](governance/AGENTS.md) | Harness vs project layout |
| [deployment.md](governance/deployment.md) | Installation and adoption |
| [workflow.md](governance/workflow.md) | Feature lifecycle |
| [protocol.md](governance/protocol.md) | Collaboration rules |
| [schemas.md](governance/schemas.md) | Data formats |
| [spec_guidelines.md](governance/spec_guidelines.md) | Specification contract |
| [human_gates.md](governance/human_gates.md) | Human approval recording |

## Design principle

**Projects adopt the harness. The harness does not know which projects use it.**

Markdown roles + governance are the source of truth. Any IDE or agent host is packaging only — configure the workspace so PROJECT_ROOT and governance are visible.
