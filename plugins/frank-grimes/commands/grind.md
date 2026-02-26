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
    description: "Comma-separated category groups to enable: 'core-quality', 'security-privacy', 'architecture-ops', 'code-structure'. Defaults to all enabled."
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
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Edit
  - Write
  - AskUserQuestion
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
```

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
      { label: "Core Quality", description: "LLM Slop, Correctness, Reliability, Error Handling, Edge Cases, Code Quality & Formatting, Maintainability" },
      { label: "Security & Privacy", description: "Security, Input Validation, Privacy & Data, Compliance" },
      { label: "Architecture & Ops", description: "Scalability, Observability, Testability, Deployment, Failure Modes, Cost, Human Factors" },
      { label: "Code Structure", description: "Code Duplication, Language-Specific Patterns, Configuration Management, Resource Lifecycle" }
    ]
    ```
  - Store the selected groups as `enabled_category_groups` and pass them to the grimey agent.

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

Once scope, categories, and mode are determined, launch the grimey agent with:
- `{target}` = resolved scope/path from step 0.1
- `{enabled_category_groups}` = selected groups from step 0.2
- `{mode}` = fix or report from step 0.3
- `{max_iterations}` = from `$ARGUMENTS` or default 5
- `{auto_loop}` = from `$ARGUMENTS` or default false
- `{with_api_review}` = from `$ARGUMENTS` or default false
