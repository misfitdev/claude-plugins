---
description: Display Frank Grimes plugin documentation and usage
allowed-tools: []
---

# Frank Grimes: Disciplined Falsification Review

The Frank Grimes plugin implements a clinical, pessimistic iteration loop for systematically destroying, rebuilding, and hardening ideas. It assumes all input is flawed until proven otherwise through survival.

## Available Commands

- `/frank-grimes:grind <target>` - Initiates a Disciplined Falsification Review on code, architecture, or plans
- `/frank-grimes:cancel` - Terminates an active grind loop and removes state data
- `/frank-grimes:help` - Displays this documentation

## Methodology: Earned Confidence

Confidence is not assumed; it is earned by surviving a relentless, adversarial critique.

1. **Assume Failure:** Every draft is broken, insecure, and unreliable by default
2. **Active Falsification:** We actively seek evidence to prove the draft wrong
3. **Evidence-First:** All identified risks must be preceded by technical evidence (code paths, logic flaws)
4. **Iterative Hardening:** We fix identified flaws and re-grind until we reach a GREEN verdict

## Quick Start

```bash
/frank-grimes:grind ./src/auth.ts --auto-loop
```

This starts a structured review that will iterate automatically until the code survives the critique or reaches maximum iterations.

## Verdicts

- **GREEN:** Confidence earned. Terminal flaws mitigated or risks explicitly accepted
- **YELLOW:** Conditional confidence. Mitigation evidence is weak or incomplete
- **RED:** Failure. Critical flaws exist without mitigation

## Command Reference

### `/frank-grimes:grind <target> [options]`

Starts a Grimes Grind on the specified target.

**Arguments:**
- `target` (required) - What to grind: file path, directory, code snippet, or description
- `--max-iterations N` (optional) - Maximum iterations before stopping (default: 5)
- `--auto-loop` (optional) - Automatically continue until GREEN verdict or max iterations reached

**Examples:**
```bash
/frank-grimes:grind ./src/auth.ts
/frank-grimes:grind "Review this architecture" --max-iterations 3 --auto-loop
/frank-grimes:grind this --auto-loop
```

### `/frank-grimes:cancel`

Terminates an active grind session and removes state data.

**When to use:**
- To stop an active grind loop without waiting for completion
- To reset state after a session interruption
- To start fresh on a new target

## Version

Frank Grimes v1.0.0 with enforced auto-loop contract validation.

For the full technical methodology, see `skills/frank-grimes/SKILL.md` in the plugin directory.
