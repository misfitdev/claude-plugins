# Hold My Beer

> "OK, but first let's think about this for 30 seconds."

A plugin that turns risky, ambitious ideas into disciplined execution plans with safety rails. Playful tone, operationally serious output.

## Philosophy

You're going to do The Thing. HMB doesn't talk you out of it. HMB makes sure you survive it.

Every plan gets:
- **Staged rollout** -- small blast radius first
- **Tripwires** -- measurable thresholds, not "monitor things"
- **Rollback** -- concrete undo steps, not "revert the change"
- **Observability** -- specific dashboards, not "check your monitoring"
- **GO / NO-GO** -- a verdict, not vibes

## Installation

Clone the repository and copy the plugin to your plugins directory:

```bash
git clone https://github.com/misfitdev/claude-plugins.git
cp -r claude-plugins/plugins/hold-my-beer ~/.claude/plugins/
```

## Commands

### `/hold-my-beer:hmb <idea> [options]`

Generate a disciplined execution plan.

**Arguments:**
- `idea` (required): What you want to do -- freeform text
- `--environment` (optional): prod / staging / dev / personal (default: prod)
- `--risk-tolerance` (optional): low / medium / high (default: low)
- `--time-budget` (optional): Time constraint (default: plan carefully)
- `--auto-loop` (optional): Iterate on the plan automatically (default: false)
- `--max-iterations` (optional): Max refinement passes (default: 3)

**Examples:**

```bash
# Midnight hotfix
/hold-my-beer:hmb "pushing a hotfix to prod at midnight"

# Weekend migration
/hold-my-beer:hmb "migrating from MySQL to Postgres" --time-budget "this weekend"

# Learning project
/hold-my-beer:hmb "building a compiler in 48 hours" --environment personal

# Auto-refine until GO
/hold-my-beer:hmb "rotating all API keys across 15 services" --auto-loop
```

### `/hold-my-beer:cancel`

Cancel an active refinement loop and report status.

### `/hold-my-beer:help`

Display help and usage information.

## How It Works

### The HMB Process

1. **Parse and Classify** -- Identify the domain, risk level, and applicable template
2. **Generate Plan** -- Fill in all 9 sections with concrete, actionable content
3. **Self-Check** -- Verify no vague language, all tripwires have numbers, rollback has commands
4. **Verdict** -- Apply the GO/NO-GO rubric

### Output: 9-Section Plan

| Section | What It Contains |
|---------|-----------------|
| THE SITUATION | What, why, and why it's risky |
| RISK CLASSIFICATION | Domain, blast radius, reversibility, time pressure |
| PREREQUISITES | Checkbox list of verifiable conditions |
| THE PLAN | Staged steps with GATE conditions |
| TRIPWIRES | Metric, threshold (a number), action (specific) |
| ROLLBACK | Concrete undo commands and steps |
| OBSERVABILITY | Dashboards, logs, alerts, healthy baselines |
| COMMS | Before/during/after messages and channels |
| VERDICT | GO / GO-WITH-CONSTRAINTS / NO-GO |

### Verdicts

| Verdict | Meaning |
|---------|---------|
| **GO** | Rollback ready. Blast radius contained. Tripwires defined. Observability in place. |
| **GO-WITH-CONSTRAINTS** | Mostly ready. Constraints listed explicitly. |
| **NO-GO** | Critical blocker. Fix it first, then come back. |

### Domains

HMB auto-detects and selects the right template:

| Domain | Covers |
|--------|--------|
| Software Release | Deploys, hotfixes, feature rollouts |
| Infrastructure | Migrations, DNS changes, cloud moves |
| Data Change | Backfills, schema changes, deletions |
| Security | Key rotation, CVE patches, access control |
| Personal/Learning | Ambitious side projects, learning stunts |

## Safety Rails

- **Rollback is always included.** Even if you say "skip it."
- **[IRREVERSIBLE] labels** on anything that cannot be undone.
- **Monitoring is never fully disabled.** Suppress noisy alerts, keep critical ones.
- **One question max.** Only if safety depends on the answer.
- **Refuses** illegal activity, attacks on unowned systems, financial/medical advice.

## Auto-Loop Behavior

When `--auto-loop` is enabled:
1. The stop hook intercepts exit attempts
2. If verdict is not GO and iterations remain, the plan is refined
3. State is persisted in `~/.cache/claude-plugins/hold-my-beer/sessions/`
4. Loop exits when GO or max iterations reached

## Dependencies

- `jq` -- Required for the stop hook to parse state JSON

Install on macOS: `brew install jq`
Install on Ubuntu: `apt-get install jq`

## Cross-Platform Usage

See `integrations/USAGE.md` for guides on using HMB with:
- Cursor (VS Code fork)
- Gemini / Google AI Studio
- ChatGPT / OpenAI Playground
- GitHub Copilot

## Credits

- Built by Misfit Development
- Inspired by every engineer who has ever said "hold my beer" and then thought better of it (after the fact)

---

*"The plan isn't the thing that saves you. Having the plan is the thing that saves you."*
