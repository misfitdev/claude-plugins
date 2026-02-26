# Conductor

**Measure twice, code once.**

Conductor is a Claude Code plugin that enables **Context-Driven Development**.
It turns Claude Code into a proactive project manager that follows a strict protocol
to specify, plan, and implement software features and bug fixes.

Instead of just writing code, Conductor ensures a consistent, high-quality lifecycle
for every task: **Context -> Spec & Plan -> Implement**.

The philosophy is simple: control your code.
By treating context as a managed artifact alongside your code, you transform your
repository into a single source of truth that drives every agent interaction with
deep, persistent project awareness.

## Features

- **Plan before you build**: Create specs and plans that guide the agent for new and existing codebases.
- **Maintain context**: Ensure Claude follows style guides, tech stack choices, and product goals.
- **Iterate safely**: Review plans before code is written, keeping you firmly in the loop.
- **Work as a team**: Set project-level context for product, tech stack, and workflow preferences that become a shared foundation.
- **Build on existing projects**: Intelligent initialization for both new (Greenfield) and existing (Brownfield) projects.
- **Smart revert**: A git-aware revert command that understands logical units of work (tracks, phases, tasks) rather than just commit hashes.

## Installation

```
/plugin marketplace add misfitdev/claude-plugins
/plugin install conductor@misfitdev/claude-plugins
```

## Commands

### `/conductor:setup`

Scaffolds the project and sets up the Conductor environment.
Run once per project.

Guides you interactively through defining:
- **Product**: project context (users, product goals, high-level features)
- **Product guidelines**: standards (prose style, brand messaging, visual identity)
- **Tech stack**: technical preferences (language, database, frameworks)
- **Workflow**: team preferences (TDD, commit strategy)
- **Code style guides**: language-specific style guides copied from plugin templates

**Generated artifacts:**
- `conductor/product.md`
- `conductor/product-guidelines.md`
- `conductor/tech-stack.md`
- `conductor/workflow.md`
- `conductor/code_styleguides/`
- `conductor/tracks.md`

### `/conductor:new-track [description]`

Plans a new feature or bug track.
Generates a `spec.md` and `plan.md` through interactive Q&A.

**Generated artifacts:**
- `conductor/tracks/<track_id>/spec.md`
- `conductor/tracks/<track_id>/plan.md`
- `conductor/tracks/<track_id>/metadata.json`
- `conductor/tracks.md` (updated)

### `/conductor:implement [track]`

Executes the tasks defined in the specified track's plan.
Follows the workflow defined in `conductor/workflow.md` (TDD, commit cadence, etc.).

### `/conductor:status`

Displays the current progress of all tracks: completed, in-progress, and pending.

### `/conductor:review [track]`

Reviews completed work against project guidelines and the track plan.
Runs the test suite automatically and produces a structured findings report.

### `/conductor:revert [target]`

Reverts a track, phase, or task by analyzing git history.
Understands conductor's logical units of work — not just commit hashes.

## How It Works

Every project gets a `conductor/` directory committed alongside your code:

```
conductor/
  index.md              # Project context index
  product.md            # What you're building and why
  product-guidelines.md # Brand, tone, and standards
  tech-stack.md         # Technology choices
  workflow.md           # Development process rules
  tracks.md             # Registry of all tracks
  code_styleguides/     # Language-specific style guides
  tracks/
    <track_id>/
      spec.md           # Requirements for this track
      plan.md           # Phased implementation plan
      metadata.json     # Track state and timestamps
```

During implementation, Claude checks off tasks in `plan.md`, commits code after
each task, and gates phase completion on automated tests and manual verification.

## Commands Reference

| Command | Description |
| :--- | :--- |
| `/conductor:setup` | Scaffold project context and generate first track |
| `/conductor:new-track` | Plan a new feature or bug track |
| `/conductor:implement` | Execute tasks from the current track's plan |
| `/conductor:status` | Show progress across all tracks |
| `/conductor:review` | Review completed work against guidelines |
| `/conductor:revert` | Undo a track, phase, or task using git |
