# Specification Guidelines

## Purpose

This document defines the standard structure and quality requirements for every Feature Specification.

A specification is the contract between the Specification, Implementation, and Review stages of the AI Harness.

Every Feature must follow the same organization and conventions.

---

# Specification Directory

Each Feature owns a dedicated directory under `specs/`.

Example:

```
specs/
    market-data-analysis/
        requirements.md
        design.md
        tasks.md
```

These three documents are mandatory for every Feature.

---

# Specification Lifecycle

The Specification stage produces a complete implementation contract before any code is written.

| Stage | Responsible | Documents |
|---------|-------------|-----------|
| Specification | Spec Writer | requirements.md, design.md, tasks.md |
| Implementation | Implementer | Executes tasks.md |
| Review | Reviewer | Validates implementation against the complete specification |

The Specification must be approved before implementation begins.

---

# requirements.md

## Purpose

Defines **what** the Feature must accomplish in EARS notation.

This document describes the expected behavior without prescribing implementation details.

---

## Required Sections

### Overview

A concise description of the Feature.

### Goals

Business and technical objectives.

### Functional Requirements

Describe observable system behavior.

Each requirement must have a unique identifier.

Example:

```text
REQ-001

The system shall...
```

### Non-Functional Requirements

Examples include:

- Performance
- Security
- Reliability
- Scalability
- Compatibility
- Maintainability

### Acceptance Criteria

Define objective conditions that determine whether the Feature is complete.

Every acceptance criterion should be testable.

---

# design.md

## Purpose

Defines **how** the Feature satisfies the requirements.

Every design decision should support one or more requirements.

---

## Required Sections

### Overview

High-level implementation summary.

### Architecture

Components involved and their responsibilities.

### Data Flow

How information moves through the system.

### Interfaces

Public APIs.

External systems.

Input/output contracts.

### Data Model

Entities.

Relationships.

State transitions.

### Error Handling

Expected failures.

Validation rules.

Recovery behavior.

### Testing Strategy

Testing approach.

Required test types.

Coverage expectations.

---

# tasks.md

## Purpose

Defines the implementation plan.

Tasks describe the work required to implement the approved design.

Tasks should be:

- small
- deterministic
- independently verifiable

---

## Required Sections

### Implementation Tasks

Example:

```markdown
- [ ] Create domain model (REQ-001)

- [ ] Implement parser (REQ-002)

- [ ] Add validation (REQ-003)

- [ ] Write unit tests (REQ-001, REQ-002, REQ-003)

- [ ] Update documentation
```

Tasks should reference the related requirements whenever applicable.

Tasks should be ordered to minimize implementation dependencies.

---

# Traceability

Every requirement should be traceable throughout the entire development process.

Recommended traceability chain:

```
Requirement
      │
      ▼
Design Decision
      │
      ▼
Implementation Task
      │
      ▼
Source Code
      │
      ▼
Unit Test
```

Every requirement should have:

- one or more design decisions
- one or more implementation tasks
- one or more tests

Implementation should never introduce functionality that is not justified by a requirement.

Likewise, no requirement should remain without implementation.

---

# Writing Principles

Specifications should be:

- complete
- deterministic
- unambiguous
- testable
- maintainable
- implementation-independent (requirements)
- technically consistent

Avoid:

- duplicated information
- hidden assumptions
- implementation details inside requirements
- business rules inside tasks
- unnecessary complexity

---

# Responsibilities

## Spec Writer

Produces the complete Feature Specification.

Responsible for:

- requirements.md (EARS notation)
- design.md
- tasks.md

Updates these documents whenever the Specification stage is repeated after rejection.

---

## Implementer

Uses the approved specification.

Responsible for:

- executing tasks.md
- implementing design.md
- satisfying requirements.md
- writing tests

The Implementer must not modify the specification documents.

If implementation requires specification changes, the Feature must return to the Specification stage.

---

## Reviewer

Validates that the implementation satisfies:

- requirements.md
- design.md
- tasks.md
- acceptance criteria

The Reviewer does not modify the implementation or the specification.

---

# Completion Criteria

A Feature Specification is considered complete when:

- every requirement is uniquely identified
- every requirement is testable
- every requirement has supporting design decisions
- every design decision supports one or more requirements
- every implementation task is defined
- every task contributes to one or more requirements
- acceptance criteria are complete and measurable
- traceability is preserved across all specification documents

A complete specification should allow the Implementer to execute the Feature without making architectural or functional decisions.