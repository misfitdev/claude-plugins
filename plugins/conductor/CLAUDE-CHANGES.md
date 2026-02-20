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

## Sync Process

When upstream releases a new version:
1. `git fetch origin main`
2. `git checkout claude`
3. `git merge main`
4. Resolve conflicts (mostly in converted command files)
5. Re-apply format conversion for any new/changed TOML files
6. Update this file with new changes
7. Commit
