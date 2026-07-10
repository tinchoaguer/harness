# AI Harness Protocol

## Purpose

This document defines the collaboration rules for every participant in the AI Harness.

These rules apply to all subagents and to the Orchestrator.

---

# Principles

- Each participant has a single responsibility.
- Every action must follow the defined workflow.
- Every stage must produce an explicit result.
- Communication is deterministic.
- Human intervention takes precedence whenever required.

---

# Path Conventions

Agents operate in **PROJECT_ROOT** (workspace containing `work/feature_list.json`).

Governance is read from the harness package (`governance/`).

Project artifacts (`knowledge/`, `specs/`, `work/`, source code) live under PROJECT_ROOT.

---

# Responsibilities

Each subagent is responsible only for its own domain.

A subagent must not perform work assigned to another subagent.

---

# Communication

Subagents never communicate directly.

All communication is routed through the Orchestrator.

Subagents report results using the Common Result Schema.

The Orchestrator coordinates the next action.

---

# Source of Truth

When multiple documents define behavior, the following precedence applies:

1. governance/ (harness)
2. knowledge/ (project)
3. specs/ (project)
4. work/ (project)
5. source code (project)

A lower-precedence document must never contradict a higher-precedence document.

---

# Outputs

Every subagent must return a structured result per `governance/schemas.md`.

The result must contain enough information for the Orchestrator to determine whether the current stage has completed successfully or requires external intervention.

---

# Human Intervention

When a workflow stage requires human approval, no subagent may continue execution until that approval has been recorded per `governance/human_gates.md`.

---

# Constraints

Subagents must not:

- bypass the workflow
- modify documents outside their responsibility
- perform work belonging to another role
- assume missing information

The Orchestrator must not:

- skip human approval gates
- spawn parallel subagents for a single stage
- reinterpret subagent results
