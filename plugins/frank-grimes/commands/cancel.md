---
description: Cancel an active Grimes Grind loop or manage session state
arguments:
  - name: status
    description: "Set to 'status' to report the active grind without cancelling it"
    required: false
allowed-tools:
  - Bash
  - Read
---

# Cancel Command

Terminates the active Grimes Grind loop.

Grind state lives in a single fixed file — `~/.cache/misfitdev-plugins/frank-grimes/sessions/grimes-state.json` — shared by the grind command and the auto-loop stop hook. There is at most one active grind at a time.

## Execution

### Default (no arguments): Terminate Active Grind

1. Check for the state file: `~/.cache/misfitdev-plugins/frank-grimes/sessions/grimes-state.json`.
2. If found:
   - Read and report a clinical summary (target, iterations, verdict, issue counts).
   - Delete the state file. This stops the auto-loop: with no state file, the stop hook allows exit.
3. If not found:
   - Report: "No active grind found."

### Status Only (`status`)

1. Read the state file and report the summary without deleting it.
2. If not found, report: "No active grind found."

## Output Examples

**Terminate active grind:**
```
Grimes Grind terminated.

Target: auth_logic.py
Status:
- Iterations: 2 of 5
- Last Verdict: YELLOW
- Issues identified: 8
- Issues mitigated: 3

State file removed. Auto-loop will not continue.
```

**No active grind:**
```
No active grind found.
```
