# AI Harness Schemas

## Purpose

This document defines the data schemas shared across the AI Harness.

Every persistent artifact and every message exchanged between the Orchestrator and the subagents must conform to these schemas.

Specification structure is defined in `governance/spec_guidelines.md`.

All project paths are relative to **PROJECT_ROOT** (workspace containing `work/feature_list.json`).

---

# Persistent Artifacts

## Feature List

**Location:** `work/feature_list.json`

**Format:** JSON

**Schema:**

```yaml
- id: number
  slug: string
  title: string
  description: string
  acceptance:
    - string
  status: Pending | In Progress | Done | Blocked
```

---

## Current Progress

**Location:** `work/progress/current.md`

**Format:** YAML frontmatter + optional Markdown body

**Schema:**

```yaml
feature:
  id: number
  slug: string

workflow_stage:
  - Specification
  - Waiting for Specification Approval
  - Implementation
  - Code Review
  - Completed
  - Blocked

status: Pending | In Progress | Done | Blocked

blocked_from_stage: string  # required when workflow_stage is Blocked

started: YYYY-MM-DD
updated: YYYY-MM-DD

approval:
  specification: pending | approved | rejected
  recorded_by: human
  recorded_at: YYYY-MM-DDTHH:MM:SS  # optional

plan:
  - string
```

---

## Feature History

**Location:** `work/history/<slug>.md` (one file per completed feature)

**Format:** Markdown

**Schema:**

```yaml
history:
  - date: YYYY-MM-DD
    feature:
      id: number
      slug: string
    workflow_stage: Completed
    pull_request: string  # optional
```

---

## Feature Specification

**Location:** `specs/<slug>/`

**Contract:** `governance/spec_guidelines.md`

**Required files:**

```text
specs/<slug>/requirements.md
specs/<slug>/design.md
specs/<slug>/tasks.md
```

---

## Review Report

**Location:** `work/progress/reviews/<slug>.md` (optional persistent copy)

**Format:** Markdown

**Schema:**

```yaml
feature:
  slug: string

decision: APPROVED | REJECTED

summary: string

requirements:
  - id: REQ-NNN
    status: pass | fail | not_applicable
    notes: string

acceptance_criteria:
  - criterion: string
    status: pass | fail
    notes: string

findings:
  - severity: required | recommendation
    location: string
    description: string
    related_req: REQ-NNN  # optional

tasks_verified:
  - task: string
    status: done | incomplete
```

---

# Workflow Mapping

Maps workflow stages to feature list `status`:

| workflow_stage | feature_list.status |
|----------------|---------------------|
| Specification | In Progress |
| Waiting for Specification Approval | In Progress |
| Implementation | In Progress |
| Code Review | In Progress |
| Completed | Done |
| Blocked | Blocked |

---

# Agent Communication

## Common Input

**Format:** YAML

**Schema:**

```yaml
feature:
  id: number
  slug: string

stage: string  # workflow_stage name

objective: string

context:
  description: string
  acceptance:
    - string
```

---

## Common Result

**Format:** YAML

**Schema:**

```yaml
stage: string  # workflow_stage name

status: COMPLETED | BLOCKED | FAILED

decision: APPROVED | REJECTED  # required for Code Review and human gates

summary: string

artifacts:
  - string  # paths relative to PROJECT_ROOT

blocked_reason: string  # required when status is BLOCKED
```

### Status and decision usage

| Stage | status | decision |
|-------|--------|----------|
| Specification | COMPLETED, BLOCKED, FAILED | — |
| Implementation | COMPLETED, BLOCKED, FAILED | — |
| Code Review | COMPLETED, BLOCKED, FAILED | APPROVED or REJECTED |
| Human specification approval | — | recorded in progress file (see human_gates.md) |

### Workflow event mapping

| Workflow event | Common Result |
|----------------|---------------|
| COMPLETED | status: COMPLETED |
| FAILED | status: FAILED |
| BLOCKED | status: BLOCKED |
| APPROVED (review) | status: COMPLETED, decision: APPROVED |
| REJECTED (review) | status: COMPLETED, decision: REJECTED |

Canonical specification artifact paths:

```text
specs/<slug>/requirements.md
specs/<slug>/design.md
specs/<slug>/tasks.md
```
