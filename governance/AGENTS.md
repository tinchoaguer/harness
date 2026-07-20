# AI Harness

## Purpose

The AI Harness is an **agnostic, reusable framework** for Specification-Driven Development (SDD).

It separates reusable governance and agents from project-specific knowledge, specifications, work tracking, and source code.

**Projects adopt the harness.** The harness does not know which projects use it.

---

# Path Conventions

## PROJECT_ROOT

The **project root** is the Cursor workspace root that contains:

- `work/feature_list.json`
- `knowledge/`

All project paths in agent instructions are relative to PROJECT_ROOT unless stated otherwise.

## Harness package

The **harness package** contains reusable governance and agents. Projects link to it via submodule, copy, or Cursor rules (see `governance/deployment.md`).

Governance paths (`governance/AGENTS.md`, `governance/spec_guidelines.md`, etc.) refer to the harness governance location configured for the project.

---

# Harness Package Structure

Reusable assets shipped with the harness:

```
harness/
    governance/
        AGENTS.md
        protocol.md
        workflow.md
        schemas.md
        spec_guidelines.md
        deployment.md
        human_gates.md
    agents/
        orchestrator.md
        git-preflight.md
        spec-writer.md
        implementer.md
        reviewer.md
```

Deploy `agents/` to `~/.cursor/agents/` for cross-project reuse.

---

# Project Adoption Structure

Each project that adopts the harness must provide:

```
<PROJECT_ROOT>/
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
        <slug>/
            requirements.md
            design.md
            tasks.md
    <source code>
```

Source code layout is defined in `knowledge/architecture.md` for that project.

Specification structure is defined in `governance/spec_guidelines.md` (reusable).

---

# Responsibilities by Location

## governance/ (harness — reusable)

Defines how the harness operates:

- workflow and protocol
- shared schemas
- specification guidelines (`spec_guidelines.md`)
- deployment and human-gate rules

Highest authority. Never overridden by project documents.

## agents/ (harness — reusable)

Defines every AI participant. Each agent owns exactly one responsibility.

## knowledge/ (project)

Project-specific context:

- architecture and module layout
- coding conventions
- architecture decision records (ADRs)

Guides implementation but never overrides governance.

## specs/ (project)

One directory per Feature: `specs/<slug>/` with `requirements.md`, `design.md`, and `tasks.md`.

Produced by the Spec Writer. Immutable during Implementation unless the workflow returns to Specification.

## work/ (project)

Execution state: feature backlog, current progress, history.

## Source code (project)

Application code. Writable paths defined in `knowledge/architecture.md`. Only the Implementer modifies source.

---

# Governance Hierarchy

When multiple documents define behavior, precedence is:

1. governance/ (harness)
2. knowledge/ (project)
3. specs/ (project)
4. work/ (project)
5. source code (project)

A lower-level document must never contradict a higher-level document.

---

# Agent Responsibilities

| Agent | Responsibility |
|-------|----------------|
| Orchestrator | Coordinate workflow execution; update `work/` |
| Git Preflight | Verify git readiness before Specification |
| Spec Writer | Produce `specs/<slug>/` per `spec_guidelines.md` |
| Implementer | Implement approved specs; modify project source |
| Reviewer | Validate implementation against full specification |


No agent may perform another agent's responsibilities.

---

# Workflow Overview

Every Feature follows the same lifecycle:

```
User
    │
    ▼
Git Preflight
    │
    ▼
Specification
    │
    ▼
Human Approval
    │
    ▼
Implementation
    │
    ▼
Review
    │
    ▼
Completed
```

Git Preflight failure on `Start Feature` refuses the start (Feature stays Pending).

Failures after a Feature has started transition to **Blocked**.

Rejected specifications return to **Specification**.

Rejected reviews return to **Implementation**.

The complete workflow is defined in `governance/workflow.md`.

Human approval recording is defined in `governance/human_gates.md`.

---

# Shared Communication

All agents:

- receive the Common Input Schema
- return the Common Result Schema

Schema definitions: `governance/schemas.md`

Specification contract: `governance/spec_guidelines.md`

---

# Communication Rules

Agents never communicate directly. Every interaction passes through the Orchestrator.

```
User
   │
   ▼
Orchestrator
   │
   ├────────────► Git Preflight
   │
   ├────────────► Spec Writer
   │
   ├────────────► Implementer
   │
   └────────────► Reviewer
```

---

# Operating Principles

Every participant must:

- follow the workflow exactly
- respect responsibility boundaries
- produce deterministic results
- never invent missing information
- return structured outputs
- stop when human intervention is required

---

# Source of Truth

Behavior is defined by:

1. Governance (harness)
2. Knowledge (project)
3. Specifications (project)
4. Work state (project)

Source code reflects implementation, not governance.
