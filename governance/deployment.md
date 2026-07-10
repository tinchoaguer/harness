# Harness Deployment

## Purpose

This document explains how to install the agnostic harness package and adopt it in a project.

The harness does not know which projects use it. Each project configures the link independently.

---

# Harness Package

The harness ships two reusable components:

```
harness/
    governance/     # rules, workflow, schemas, spec_guidelines
    agents/         # orchestrator, spec-writer, implementer, reviewer
```

Nothing else is required in the harness repository.

---

# Project Adoption Layout

Each adopting project must provide at PROJECT_ROOT:

```
knowledge/
    architecture.md
    conventions.md
    adr/
work/
    feature_list.json
    progress/
        current.md
    history/
specs/
    _template/
        requirements.md
        design.md
        tasks.md
<source code>
```

Add `HARNESS.md` at PROJECT_ROOT pointing to the harness governance location.

---

# PROJECT_ROOT

**PROJECT_ROOT** is the Cursor workspace root that contains:

- `work/feature_list.json`
- `knowledge/`

Open Cursor with PROJECT_ROOT as the workspace when running the harness workflow.

---

# Installing Agents

Copy or symlink harness agents to the global Cursor agents directory:

```text
harness/agents/orchestrator.md   → ~/.cursor/agents/orchestrator.md
harness/agents/spec-writer.md    → ~/.cursor/agents/spec-writer.md
harness/agents/implementer.md    → ~/.cursor/agents/implementer.md
harness/agents/reviewer.md       → ~/.cursor/agents/reviewer.md
```

Agents are path-agnostic. They resolve PROJECT_ROOT from the open workspace.

---

# Linking Governance

Choose one approach per project:

## Option A: Sibling harness repo (recommended for this monorepo)

```
market-data-proyect/
    harness/           # governance source
    market-data-be/    # PROJECT_ROOT
```

Reference governance via relative path in `HARNESS.md` or Cursor rules:

```text
../harness/governance/
```

## Option B: Git submodule

```bash
git submodule add <harness-repo-url> .harness
```

Governance path: `.harness/governance/`

## Option C: Copy

Copy `harness/governance/` into the project. Update manually when the harness evolves.

---

# Bootstrap Checklist

1. Create `knowledge/`, `work/`, `specs/` directories
2. Copy `specs/_template/` from spec_guidelines structure
3. Initialize `work/feature_list.json` and `work/progress/current.md`
4. Write `knowledge/architecture.md` for this repo
5. Write `knowledge/conventions.md`
6. Add `HARNESS.md` with governance path
7. Install agents to `~/.cursor/agents/`
8. Add features to `work/feature_list.json`
9. Run: `Start Feature <slug>`

---

# Invoking the Harness in Cursor

1. Open the **project workspace** (e.g. `market-data-be/`)
2. Start the **Orchestrator** agent
3. User command: `Start Feature <slug>`
4. Orchestrator invokes subagents one stage at a time via Cursor Task tool or agent handoff
5. User approves specification at the human gate (see `human_gates.md`)

---

# Cross-Repo Features

The harness does not coordinate features across multiple repositories.

If a feature spans backend and frontend:

- **Split:** one feature per repo with linked slugs in descriptions, or
- **Meta-project:** a parent workspace owns `work/` and `specs/` and documents which repos each task targets

Document the chosen pattern in the project's `knowledge/architecture.md`.

---

# Upgrading

When harness governance changes:

1. Pull or copy updated `governance/` files
2. Verify agent files in `~/.cursor/agents/` match `harness/agents/`
3. In-flight features continue under the workflow version active when they started (record harness version in `work/progress/current.md` if needed)

---

# Error Handling

| Common Result status | Orchestrator action |
|---------------------|---------------------|
| COMPLETED | Transition per workflow.md |
| FAILED | Set workflow_stage to Blocked; record blocked_from_stage |
| BLOCKED | Set workflow_stage to Blocked; wait for user Resume |

Review `decision` field:

| decision | Next stage |
|----------|------------|
| APPROVED | Completed (from Code Review) |
| REJECTED | Implementation |

Idempotent re-runs: re-invoking a stage after rejection replaces prior stage artifacts for that cycle.
