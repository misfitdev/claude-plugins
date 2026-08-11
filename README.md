# Misfit Development Plugins

Cross-platform development workflows for AI coding agents, maintained by Misfit Development.
The canonical plugin logic is host-neutral; adapters package it for both Claude Code and Codex.

Marketplace name: **`misfitdev-plugins`**

## Plugins

| Plugin | Purpose | Claude Code | Codex |
|---|---|---:|---:|
| Frank Grimes | Evidence-first falsification review and hardening | `/frank-grimes:grind` | `$frank-grimes` |
| Hold My Beer | Disciplined execution for risky or ambitious changes | `/hold-my-beer:hmb` | `$hold-my-beer` |

## Repository layout

```
plugins/
  <plugin>/
    .claude-plugin/      # Claude Code adapter metadata
    .codex-plugin/       # Codex adapter metadata
    commands/            # Claude Code command adapters
    hooks/               # Host lifecycle adapters, when supported
    skills/              # Canonical workflows shared by both hosts
    README.md            # Plugin-specific docs
```

The same `misfitdev-plugins` catalog is exposed through `.claude-plugin/marketplace.json`
for Claude Code and `.agents/plugins/marketplace.json` for Codex.

The repository is still named `misfitdev/claude-plugins`; that is only the current Git source
address. The marketplace identity is already model-agnostic and will survive a later repository rename.

## Installation

### Claude Code

Add the current Git repository as a marketplace, then install either plugin:

```text
/plugin marketplace add misfitdev/claude-plugins
/plugin install frank-grimes@misfitdev-plugins
/plugin install hold-my-beer@misfitdev-plugins
```

### Codex

Add this Git repository as a marketplace, then install a plugin:

```bash
codex plugin marketplace add misfitdev/claude-plugins
codex plugin add frank-grimes@misfitdev-plugins
codex plugin add hold-my-beer@misfitdev-plugins
```

Start a new Codex thread after installation so its skills are loaded. Invoke the main workflows with
`$frank-grimes` or `$hold-my-beer`.

## Documentation

Each plugin has its own README in `plugins/<plugin>/README.md`.

## License

MIT
