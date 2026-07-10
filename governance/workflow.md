# AI Harness Workflow

## Purpose

This document defines the execution flow of a Feature within PROJECT_ROOT.

The Orchestrator must execute this workflow exactly as defined.

Specification structure: `governance/spec_guidelines.md` (`specs/<slug>/`).

Human approval: `governance/human_gates.md`.

---

# Trigger

A workflow begins when the user requests:

> Start Feature <slug>

The `slug` must match an entry in `work/feature_list.json` and `specs/<slug>/`.

---

# Stages

## 1. Specification

**Responsible**

- Spec Writer

**Output**

- `specs/<slug>/requirements.md`
- `specs/<slug>/design.md`
- `specs/<slug>/tasks.md`

**Next**

- Waiting for Specification Approval

---

## 2. Waiting for Specification Approval

**Responsible**

- Human

**Possible Decisions**

- Approved
- Rejected

**Next**

- Approved → Implementation
- Rejected → Specification

---

## 3. Implementation

**Responsible**

- Implementer

**Output**

- Source code
- Unit tests

**Next**

- Code Review

---

## 4. Code Review

**Responsible**

- Reviewer

**Possible Decisions**

- Approved
- Rejected

**Next**

- Approved → Completed
- Rejected → Implementation

---

## 5. Completed

The Feature has been successfully implemented and reviewed.

The workflow terminates.

---

## 6. Blocked

The workflow cannot continue.

Execution remains suspended until external intervention.

Once resumed, execution continues from the stage where the Feature was blocked.

---

# Workflow Transition Table

| Current Stage | Event | Next Stage |
|---------------|-------|------------|
| Specification | COMPLETED | Waiting for Specification Approval |
| Specification | FAILED | Blocked |
| Waiting for Specification Approval | APPROVED | Implementation |
| Waiting for Specification Approval | REJECTED | Specification |
| Implementation | COMPLETED | Code Review |
| Implementation | FAILED | Blocked |
| Code Review | APPROVED | Completed |
| Code Review | REJECTED | Implementation |
| Code Review | FAILED | Blocked |
| Blocked | RESUME | Previous Stage |

---

# Transition Rules

## Specification Rejected

A rejected specification returns to the **Specification** stage.

The Spec Writer must update the specification before it can be submitted again.

---

## Code Review Rejected

A rejected implementation returns to the **Implementation** stage.

The Implementer must address the review findings before requesting another review.

---

## Blocked

A Feature enters the **Blocked** stage when execution cannot continue due to an unexpected condition.

Examples include:

- execution failure
- missing required information
- unexpected error

No automatic recovery is allowed.

Execution resumes only after an explicit user request.

The Feature resumes from the stage where it became blocked.