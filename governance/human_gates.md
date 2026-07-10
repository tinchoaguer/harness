# Human Gates

## Purpose

This document defines how human approval and rejection are recorded during the workflow.

Human decisions take precedence over agent execution.

---

# Specification Approval Gate

## Stage

**Waiting for Specification Approval** (workflow stage 2)

## Responsible

Human

## Recording location

`work/progress/current.md` — update the `approval` block:

```yaml
approval:
  specification: approved  # or rejected
  recorded_by: human
  recorded_at: 2026-07-06T15:00:00
  notes: optional comment
```

## Commands

The user must issue an explicit command. Examples:

```text
Approve specification
Reject specification: <reason>
```

The Orchestrator must not infer approval from informal chat.

## Transitions

| Decision | Next workflow_stage |
|----------|---------------------|
| approved | Implementation |
| rejected | Specification |

---

# Blocked Resume

## Stage

**Blocked**

## Recording

When resuming, the user issues:

```text
Resume Feature <slug>
```

The Orchestrator reads `blocked_from_stage` from `work/progress/current.md` and continues from that stage.

## On block

When a subagent returns `status: BLOCKED`, the Orchestrator must:

1. Set `workflow_stage` to `Blocked`
2. Set `blocked_from_stage` to the stage where execution stopped
3. Set `feature_list.json` status to `Blocked`
4. Record `blocked_reason` from the Common Result

---

# Review Approval

Code Review approval is **agent-autonomous** unless the project adds a human review gate.

The Reviewer sets `decision: APPROVED` or `decision: REJECTED` in the Common Result.

The Orchestrator transitions based on the Reviewer's decision without additional human approval.

---

# Who Records What

| Action | Actor | Location |
|--------|-------|----------|
| Specification approve/reject | Human | `work/progress/current.md` approval block |
| Stage progress updates | Orchestrator | `work/progress/current.md` |
| Feature status updates | Orchestrator | `work/feature_list.json` |
| Review decision | Reviewer | Common Result; optional copy in `work/progress/reviews/<slug>.md` |
| Completed feature archive | Orchestrator | `work/history/<slug>.md` |

---

# Progress File Template

See `work/progress/current.md` in the project for the active template.

When no feature is active:

```yaml
feature: null
workflow_stage: null
status: Pending
blocked_from_stage: null
started: null
updated: null
approval:
  specification: null
plan: []
```
