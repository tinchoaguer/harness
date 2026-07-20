# Harness Deployment

## Purpose

This document explains how to install the agnostic harness package and adopt it in a project.

The harness does not know which projects use it. Each project configures the link independently.

Behavior is defined by portable markdown (governance + agent role cards). IDE-specific install paths and frontmatter are **packaging only**. Any agent host that can load a markdown system prompt and open PROJECT_ROOT as the workspace can run the harness.

---

# Harness Package

The harness ships two reusable components:

```
harness/
    governance/     # rules, workflow, schemas, spec_guidelines
    agents/         # orchestrator, git-preflight, spec-writer, implementer, reviewer
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

**PROJECT_ROOT** is the workspace root that contains:

- `work/feature_list.json`
- `knowledge/`

Open the IDE (or agent host) with PROJECT_ROOT as the workspace when running the harness workflow. Agents resolve paths from that workspace.

---

# Installing Agents

Copy or symlink harness agent role cards into the directory your agent host uses for custom agents:

```text
harness/agents/orchestrator.md
harness/agents/git-preflight.md
harness/agents/spec-writer.md
harness/agents/implementer.md
harness/agents/reviewer.md
```

Destination path is host-specific (packaging only). Reuse `harness/scripts/install-agents.sh` or `install-agents.ps1`:

```bash
./install-agents.sh ../agents <host-agents-dir> symlink
```

```powershell
.\install-agents.ps1 -Source ..\agents -Destination <host-agents-dir> -Mode symlink
```

Agents are path-agnostic. They resolve PROJECT_ROOT from the open workspace.

Optional YAML frontmatter on role cards (`name`, `description`, `model`, `readonly`) is for hosts that use it. Behavior is defined by the markdown body and governance — ignore or strip frontmatter if the host does not.

Do not put harness SoT only in IDE-specific rules files; keep authority in `governance/` and `HARNESS.md`.

---

# Linking Governance

Choose one approach per project:

## Option A: Sibling harness repo (recommended for this monorepo)

```
market-data-proyect/
    harness/           # governance source
    market-data-be/    # PROJECT_ROOT
```

Reference governance via relative path in `HARNESS.md` (and any IDE rules that only point at that path):

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
7. Install agents into the host’s custom-agents directory
8. Add features to `work/feature_list.json`
9. Run: `Start Feature <slug>`

---

# Invoking the Harness

1. Open the **project workspace** (PROJECT_ROOT, e.g. `market-data-be/`)
2. Load the **Orchestrator** agent (role card as system prompt)
3. User command: `Start Feature <slug>`
4. Orchestrator invokes **Git Preflight**, then other subagents **one stage at a time**, reading each Common Result before the next stage
5. If Git Preflight is not COMPLETED, Orchestrator refuses the start and reports remediation
6. User approves specification at the human gate (see `human_gates.md`)

How the host spawns a subagent (nested task, handoff, or new session) is packaging. The contract is always: Orchestrator → one subagent → Common Result → next workflow step.

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
2. Verify installed agent role cards match `harness/agents/`
3. In-flight features continue under the workflow version active when they started (record harness version in `work/progress/current.md` if needed)

---

# Error Handling

| Common Result status | Orchestrator action |
|---------------------|---------------------|
| COMPLETED | Transition per workflow.md |
| FAILED (Git Preflight on Start Feature) | Refuse start; leave Feature Pending; report summary |
| BLOCKED (Git Preflight on Start Feature) | Refuse start; leave Feature Pending; report blocked_reason |
| FAILED (after Feature started) | Set workflow_stage to Blocked; record blocked_from_stage |
| BLOCKED (after Feature started) | Set workflow_stage to Blocked; wait for user Resume |

Review `decision` field:

| decision | Next stage |
|----------|------------|
| APPROVED | Completed (from Code Review) |
| REJECTED | Implementation |

Idempotent re-runs: re-invoking a stage after rejection replaces prior stage artifacts for that cycle.
