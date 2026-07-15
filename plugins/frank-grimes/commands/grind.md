---
description: Start a Grimes Grind - a clinical, pessimistic iteration loop to find everything wrong with an idea, code, or design
arguments:
  - name: target
    description: What to grind (file path, directory, description, or "this" for current context). If omitted, scope will be asked interactively.
    required: false
  - name: scope
    description: "Shorthand scope: 'recent-changes' (git diff), 'whole-repo', or a custom path/description. Skips the scope question."
    required: false
  - name: categories
    description: "Comma-separated category groups to enable: 'core-quality', 'security-privacy', 'architecture-ops', 'code-structure'. Defaults to all enabled. The Documentation group is not a value here — enable it with --docs-review."
    required: false
  - name: mode
    description: "Output mode: 'fix' (apply fixes automatically, default) or 'report' (report findings only, no edits)"
    required: false
  - name: max-iterations
    description: Maximum grind iterations before stopping (default 5)
    required: false
  - name: auto-loop
    description: Enable automatic iteration until GREEN verdict (default false)
    required: false
  - name: with-api-review
    description: Enable Phase 2 API Correctness review after Phase 1 (default false)
    required: false
  - name: docs-review
    description: "Enable documentation & comments critique (grime-doc-*, grime-api-doc-*). Off by default."
    required: false
  - name: no-artifact
    description: "Suppress publishing the report as a clickable Claude web artifact. Artifact is published by default."
    required: false
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Edit
  - Write
  - AskUserQuestion
  - Skill
  - Artifact
---

# Grimes Grind Command

Execute a Grimes Grind on the target using the grimey agent.

**Arguments:**
- `target` / `scope`: What to review — file path, directory, `recent-changes`, `whole-repo`, or a description
- `categories`: Which category groups to evaluate (default: all four groups enabled)
- `mode`: `fix` (default) or `report` — whether to apply fixes or report only
- `max-iterations`: Stop after N iterations (default 5)
- `auto-loop`: Loop until GREEN verdict if enabled (default false)
- `with-api-review`: Enable Phase 2 API Correctness & Completeness review (default false)
- `docs-review`: Enable documentation & comments critique (default false — off)
- `no-artifact`: Suppress the clickable web-artifact report (published by default)

**Return format:** GRIMES_RESULT JSON with verdict, findings, and fixes

**Examples:**

```bash
# Interactive setup (asks scope, categories, mode)
/frank-grimes:grind

# Phase 1 only (runtime reliability)
/frank-grimes:grind ./src/auth.go

# Recent changes, report only, skip category selection
/frank-grimes:grind --scope recent-changes --mode report

# Both phases (runtime + API correctness)
/frank-grimes:grind ./src/api --with-api-review

# Auto-loop with API review enabled
/frank-grimes:grind ./proto-mcp --with-api-review --auto-loop

# Include documentation/comments critique (off by default)
/frank-grimes:grind ./src --docs-review

# Suppress the clickable web-artifact report (published by default)
/frank-grimes:grind ./src --no-artifact
```

**Defaults note:** `--docs-review` (off) and `--no-artifact` (artifact on) are read
directly from `$ARGUMENTS` — they have no interactive prompt. If absent, docs
critique stays off and the report artifact is published.

---

## 0.0 SESSION SETUP

**PROTOCOL: Determine session configuration before starting. Skip any question whose answer was already provided in `$ARGUMENTS`.**

### 0.1 Scope

- **If `$ARGUMENTS` contains a `target`, `scope`, or a file/directory path:** Use it directly. Skip this step.
- **Otherwise**, use the **AskUserQuestion** tool:
  - question: "What should I grind?"
  - header: "Scope"
  - options:
    ```
    [
      { label: "Recent changes", description: "Review files changed in the last commit or currently staged/unstaged (git diff)" },
      { label: "Whole repo", description: "Scan the entire repository" },
      { label: "Something else", description: "I'll describe the target (file path, code snippet, architecture, etc.)" }
    ]
    ```
  - If "Something else" is selected (or the user writes a custom answer), ask them to describe the target and use their response as the scope.
  - **Scope resolution:**
    - "Recent changes" → run `git diff HEAD` and `git diff --staged` to identify changed files; target those files
    - "Whole repo" → use the repository root as the target
    - Custom → use the provided path/description as the target

### 0.2 Evaluation Categories

- **If `$ARGUMENTS` contains `--categories` or `categories`:** Parse the value and use those groups. Skip this step.
- **Otherwise**, use the **AskUserQuestion** tool with `multiSelect: true` (present all options pre-selected — the user deselects to disable):
  - question: "Which evaluation categories should I run? (all enabled by default — deselect to skip)"
  - header: "Categories"
  - multiSelect: true
  - options:
    ```
    [
      { label: "Core Quality", description: "LLM Slop, Correctness, Reliability, Error Handling, Edge Cases, Code Quality & Formatting, Maintainability, Existence Justification, Structural/Design, Better Design" },
      { label: "Security & Privacy", description: "Security, Input Validation, Privacy & Data, Compliance, Safety/Security Theater" },
      { label: "Architecture & Ops", description: "Scalability, Observability, Testability, Deployment, Failure Modes, Cost, Human Factors" },
      { label: "Code Structure", description: "Code Duplication, Language-Specific Patterns, Configuration Management, Resource Lifecycle" }
    ]
    ```
  - Store the selected groups as `enabled_category_groups` and pass them to the grimey agent.
  - The **Documentation** group is not offered here — it is enabled solely by `--docs-review` (off by default).

### 0.3 Mode

- **If `$ARGUMENTS` contains `--mode fix`, `--mode report`, or `mode=`:** Use the provided value. Skip this step.
- **Otherwise**, use the **AskUserQuestion** tool:
  - question: "Should I apply fixes automatically or just report findings?"
  - header: "Mode"
  - options:
    ```
    [
      { label: "Fix (Recommended)", description: "Apply fixes automatically as issues are found" },
      { label: "Report Only", description: "Identify and document all issues but make no file edits" }
    ]
    ```
  - Map "Fix (Recommended)" → `mode=fix`, "Report Only" → `mode=report`.

---

## 1.0 EXECUTE GRIND

Once scope, categories, and mode are determined, **execute the Grimes Grind inline in this session — you are grimey.** The grind runs inline (not as a spawned subagent) because three of its duties require the main session: the Phase 4b redesign accept/reject prompt (AskUserQuestion), the report artifact (Artifact tool), and the auto-loop stop hook's state handshake. Adopt the grimey persona and run the methodology (section 2.0) with the resolved configuration.

**Initialize the state file** at `~/.cache/claude-plugins/frank-grimes/sessions/grimes-state.json` before Phase 1 (create or overwrite for a new grind): set `iteration: 1`, `max_iterations`, `last_verdict: "RED"`, `target`, `auto_loop`, `issues_found: 0`, `issues_fixed: 0`, `last_commit: null`, `last_grind_timestamp: null`. The stop hook requires the first five fields and deletes the file (silently disabling auto-loop) if any is missing.

**Resolved configuration:**
- **Target / Scope:** (from step 0.1)
- **Enabled category groups:** (from step 0.2)
- **Mode:** (from step 0.3) — `fix` = apply edits; `report` = document only, no edits
- **Max iterations:** from `$ARGUMENTS` or default 5
- **Auto-loop:** from `$ARGUMENTS` or default false
- **Phase 2 (API Review):** from `$ARGUMENTS` or default false
- **Docs review:** from `$ARGUMENTS` (`--docs-review`) or default **false**
- **Publish artifact:** default **true**; suppressed only by `--no-artifact`
- **Current iteration:** 1
- **Previous findings:** none (first iteration)

---

## 2.0 GRIMEY METHODOLOGY

You are now executing as the Grimes Reviewer. The canonical methodology is this plugin's skill file — read `${CLAUDE_PLUGIN_ROOT}/skills/frank-grimes/SKILL.md` (the frank-grimes skill) and execute it exactly with the resolved configuration. Do not improvise a variant; SKILL.md is the single source of truth for phases, categories, formats, and gating rules.

Execution summary (details in SKILL.md):

- **Phases:** 1 (Grimey Read) → 2 (Default Assumptions) → 3 (The Grind) → 4 (The Rebuild) → 4b (Redesign Handling) → 5 (Scoped Re-Grind) → 6 (Stop Conditions & Verdict) → 7 (API Quality, only with `--with-api-review`) → 8 (Report Artifact, unless `--no-artifact`).
- **Categories:** run only the groups in `enabled_category_groups` (mapping table in SKILL.md). The Documentation group runs only when `--docs-review` is set; when it is off, never critique or penalize absent documentation.
- **Mode:** enforce `fix` vs `report` per SKILL.md's mode-enforcement rules. In `fix` mode, apply mechanical fixes first (committing each); grime-redesign-* findings always go through the Phase 4b accept/reject pause — it blocks even under `--auto-loop` and never auto-applies a reshaping.
- **Formats:** use SKILL.md's Evidence-First issue format (BLUF line first), fix format, and Grimes Report template.

---

## 3.0 STRUCTURED RETURN

After Phase 6 (and Phase 7 if enabled), output the following structured result. This is non-negotiable — it enables auto-loop orchestration:

```
GRIMES_RESULT: {
  "iteration": <current iteration number>,
  "max_iterations": <maximum allowed iterations>,
  "verdict": "GREEN|YELLOW|RED",
  "issues_found": <count of total issues identified>,
  "issues_fixed": <count of issues remediated>,
  "grime_findings": [
    {
      "grime_id": "grime-xxx-123",
      "category": "Category name",
      "severity": "P0|P1|P2|P3",
      "status": "FIXED|UNFIXED",
      "evidence": "Specific code path, scenario, or evidence",
      "fix_applied": "Description of fix applied, or null if unfixed"
    }
  ],
  "commit_hash": "abc1234... or null",
  "summary": "One-sentence BLUF describing the verdict"
}
```

Then update the state file at `~/.cache/claude-plugins/frank-grimes/sessions/grimes-state.json`: set `last_verdict`, `issues_found`, `issues_fixed`, `last_commit`, `last_grind_timestamp`. Preserve all other fields.

**If `auto_loop=true` and verdict is RED or YELLOW and current iteration < max_iterations:** Start the next iteration immediately. Carry forward unfixed findings as `previous_context` and increment `iteration`. Repeat from Phase 1 with narrowed focus on remaining P0/P1 issues. **Auto-loop still blocks at the Phase 4b redesign accept/reject prompt — that is the one intentional stop in an otherwise-unattended loop; it never auto-applies a reshaping.**

The redesign accept/reject and re-grind outcomes are recorded within the existing `grime_findings[]` / `status` / `fix_applied` fields — no schema change.

---

**Begin Phase 1 now.**
