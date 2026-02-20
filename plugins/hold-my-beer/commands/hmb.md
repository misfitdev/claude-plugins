---
description: Hold My Beer - plan it fast, then do it. Risky idea in, executed result out. Safety rails included whether you asked or not.
arguments:
  - name: idea
    description: What you want to do - freeform description of The Thing
    required: true
  - name: environment
    description: Target environment (prod, staging, dev, personal). Default prod.
    required: false
  - name: risk-tolerance
    description: Risk tolerance level (low, medium, high). Default low.
    required: false
  - name: time-budget
    description: How much time you have (e.g., "2 hours", "this weekend"). Default unlimited.
    required: false
  - name: auto-loop
    description: Enable automatic refinement iterations (default false)
    required: false
  - name: max-iterations
    description: Maximum refinement iterations before stopping (default 3)
    required: false
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Edit
  - Write
---

# Hold My Beer Command

Plan fast, then execute. Takes a risky or ambitious idea, sketches the plan with safety rails, and immediately does the thing.

**Arguments:**
- `idea` (required): What you want to do (freeform text, file path, or description)
- `--environment` (optional): prod / staging / dev / personal (default: prod)
- `--risk-tolerance` (optional): low / medium / high (default: low)
- `--time-budget` (optional): Time constraint (default: plan carefully)
- `--auto-loop` (optional): Iterate on the plan automatically (default: false)
- `--max-iterations` (optional): Max refinement passes (default: 3)

**Return format:** HMB_RESULT JSON with verdict, domain, risk level, and plan summary

**Examples:**

```bash
# Production hotfix
/hold-my-beer:hmb "pushing a hotfix to prod at midnight"

# Database migration with time constraint
/hold-my-beer:hmb "migrating from MySQL to Postgres" --environment prod --time-budget "this weekend"

# Personal learning project
/hold-my-beer:hmb "building a compiler in 48 hours" --environment personal --risk-tolerance high

# Auto-refine the plan
/hold-my-beer:hmb "rotating all API keys across 15 services" --auto-loop --max-iterations 3
```
