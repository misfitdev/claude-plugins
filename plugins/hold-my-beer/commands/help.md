---
description: Display Hold My Beer plugin documentation and usage
allowed-tools: []
---

# Hold My Beer: Disciplined Execution Planning

The Hold My Beer plugin turns risky, ambitious ideas into structured execution plans with safety rails. Playful tone, operationally serious output.

## Available Commands

- `/hold-my-beer:hmb <idea>` - Generate an execution plan for a risky or ambitious idea
- `/hold-my-beer:cancel` - Terminate an active refinement loop
- `/hold-my-beer:help` - Display this documentation

## What It Does

You describe The Thing you want to do. HMB produces a plan with:

1. **Staged execution** -- small blast radius first, widen only on success
2. **Tripwires** -- measurable thresholds that trigger pause, rollback, or escalation
3. **Rollback path** -- concrete undo steps, not "revert the change"
4. **Observability** -- specific dashboards, queries, and what "bad" looks like
5. **Comms plan** -- who to tell, when, what to say
6. **GO / GO-WITH-CONSTRAINTS / NO-GO** verdict

## Quick Start

```bash
/hold-my-beer:hmb "pushing a hotfix to prod at midnight"
```

## Domains

HMB auto-detects the domain and selects the right template:

| Domain | Example |
|--------|---------|
| Software Release | "deploy hotfix to prod" |
| Infrastructure | "migrate from AWS to GCP" |
| Data Change | "backfill 10M rows" |
| Security | "rotate all API keys" |
| Personal/Learning | "build a compiler this weekend" |

## Verdicts

- **GO** -- All safety conditions met. Rollback ready. Blast radius contained.
- **GO-WITH-CONSTRAINTS** -- Conditions mostly met. Specific constraints listed.
- **NO-GO** -- Critical safety condition not met. Fix the blocker first.

## Safety Rails

- Rollback is always included, even if you say "skip it"
- Irreversible steps are labeled [IRREVERSIBLE]
- Monitoring is never disabled entirely
- One clarifying question max (only if safety depends on it)

## Command Reference

### `/hold-my-beer:hmb <idea> [options]`

**Arguments:**
- `idea` (required) - What to plan: freeform description of The Thing
- `--environment` (optional) - prod / staging / dev / personal (default: prod)
- `--risk-tolerance` (optional) - low / medium / high (default: low)
- `--time-budget` (optional) - Time constraint (default: plan carefully)
- `--auto-loop` (optional) - Iterate automatically on the plan (default: false)
- `--max-iterations` (optional) - Max refinement passes (default: 3)

**Examples:**
```bash
/hold-my-beer:hmb "migrating our primary DB this weekend" --time-budget "48 hours"
/hold-my-beer:hmb "rotating all API keys" --auto-loop
/hold-my-beer:hmb "building a game in a weekend" --environment personal --risk-tolerance high
```

### `/hold-my-beer:cancel`

Terminate an active refinement loop and report plan status.

## Version

Hold My Beer v1.1.0 with native Claude Code and Codex support.

For the full methodology, templates, and test suite, see `skills/hold-my-beer/SKILL.md` in the plugin directory.
