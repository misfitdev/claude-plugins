# Claude Branch Changes

This document tracks all modifications from the upstream Gemini extension
to make Conductor work as a Claude Code plugin.

## Format Changes
- TOML commands → Markdown with YAML frontmatter
- Command namespace: `commands/conductor/*.toml` → `commands/*.md`
- Added `allowed-tools` and `arguments` fields to each command
- Template paths changed from `~/.gemini/extensions/conductor/templates/` to relative `templates/`

## Renamed Commands
- `newTrack` → `new-track`

## Added Files
- `.claude-plugin/plugin.json`
- `skills/conductor/SKILL.md`
- `CLAUDE-CHANGES.md`

## Removed Files
- `gemini-extension.json`
- `GEMINI.md`
- `.github/workflows/release-please.yml`
- `release-please-config.json`
- `.release-please-manifest.json`

## Prompt Patches
- Removed Gemini "flash" model directive (setup)
- Changed `.geminiignore` → `.gitignore` (setup)
- Changed extension template paths from absolute `~/.gemini/extensions/conductor/templates/` to relative `templates/` (setup)
- Removed "Modify with external editor" Gemini CLI references (setup, replaced with generic editor note)
- Updated `/conductor:newTrack` → `/conductor:new-track` (all files)
- Changed `{{args}}` template variable to `$ARGUMENTS` (new-track, review)

## v0.3.1 Port
- `ask_user` tool → `AskUserQuestion` tool (all command files)

## v0.4.0 Port
- Replaced `setup_state.json`-based resume with artifact-based Project Audit (setup) — checks file existence to determine resume point
- Added two-phase planning protocol to setup and new-track (adapted from Gemini's plan mode integration: Claude has no plan mode tools, so replaced with an explicit `## Plan` block + user approval gate before any file writes)
- Fixed brownfield detection: `git status` output now filters out `conductor/` paths before classifying as dirty (setup)
- Updated code styleguides selection to use batching strategy: guides presented in groups of 3-4 with `multiSelect: true` (setup 2.4)
- Updated initial track proposal to use `AskUserQuestion` choice interface instead of text confirmation (setup 3.2)
- Removed all `setup_state.json` writes throughout setup
- Error handling updated: attempt self-correction once before halting (setup, new-track)
- Not ported (Gemini-specific): `policies/conductor.toml`, relative path enforcement in plan mode, `gemini-extension.json` plan directory config

## v0.4.1 Port
- Version bump only (upstream was a docs-only fix to remove a now-outdated warning)

## Sync Process

When upstream releases a new version:
1. `git fetch origin main`
2. `git checkout claude`
3. `git merge main`
4. Resolve conflicts (mostly in converted command files)
5. Re-apply format conversion for any new/changed TOML files
6. Update this file with new changes
7. Commit
