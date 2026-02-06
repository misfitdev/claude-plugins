---
description: Cancel an active Hold My Beer refinement loop or manage session state
arguments:
  - name: session-id
    description: "Session ID to cancel (optional, defaults to current session)"
    required: false
  - name: list
    description: "Set to 'all' to list all active HMB sessions in ~/.cache/claude-plugins/hold-my-beer/sessions/"
    required: false
allowed-tools:
  - Bash
  - Read
---

# Cancel Command

Terminates an active Hold My Beer refinement loop for the current or specified session.

## Execution

### Default (no arguments): Terminate Current Session

1. Determine session ID:
   - Use `CLAUDE_SESSION_ID` if available.
   - Otherwise, use MD5 hash of current working directory.
2. Verify existence of state file: `~/.cache/claude-plugins/hold-my-beer/sessions/{SESSION_ID}.json`.
3. If found:
   - Read and report summary (iterations, verdict, domain, stages).
   - Delete the state file.
4. If not found:
   - Report: "No active HMB session found."

### Terminate Specific Session (--session SESSION_ID)

1. Verify state file for the provided ID.
2. If found:
   - Report summary and delete file.
3. If not found:
   - Report: "Session not found."

### List All Active Sessions (--list all)

1. Enumerate all state files in `~/.cache/claude-plugins/hold-my-beer/sessions/`.
2. For each file, report: Session ID, Iteration, Last Verdict, Domain, Idea summary.

## Output Examples

**Terminate active session:**
```
HMB session terminated.

Session: abc123def456
Status:
- Iterations: 2 of 3
- Last Verdict: GO-WITH-CONSTRAINTS
- Domain: infrastructure
- Stages planned: 4

State file removed.
```

**List all active sessions:**
```
Active HMB Sessions:

- Session: abc123def456 | Iteration: 2/3 | Verdict: GO-WITH-CONSTRAINTS | Domain: infra
- Session: xyz789abc123 | Iteration: 1/3 | Verdict: NO-GO | Domain: data

Total: 2 active sessions.
```
