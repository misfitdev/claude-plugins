---
description: Start a Grimes Grind - a clinical, pessimistic iteration loop to find everything wrong with an idea, code, or design
arguments:
  - name: target
    description: What to grind (code, architecture, plan, etc.) - can be a file path, description, or "this" for current context
    required: true
  - name: max-iterations
    description: Maximum grind iterations before stopping (default 5)
    required: false
  - name: auto-loop
    description: Enable automatic iteration until GREEN verdict (default false)
    required: false
  - name: with-api-review
    description: Enable Phase 2 API Correctness review after Phase 1 (default false)
    required: false
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Edit
  - Write
---

# Grimes Grind Command

Execute a Grimes Grind on the target using the grimey agent.

**Arguments:**
- `target`: What to review (file path, directory, or description)
- `max-iterations`: Stop after N iterations (default 5)
- `auto-loop`: Loop until GREEN verdict if enabled (default false)
- `with-api-review`: Enable Phase 2 API Correctness & Completeness review (default false)

**Return format:** GRIMES_RESULT JSON with verdict, findings, and fixes

**Examples:**

```bash
# Phase 1 only (runtime reliability)
/frank-grimes:grind ./src/auth.go

# Both phases (runtime + API correctness)
/frank-grimes:grind ./src/api --with-api-review

# Auto-loop with API review enabled
/frank-grimes:grind ./proto-mcp --with-api-review --auto-loop
```
