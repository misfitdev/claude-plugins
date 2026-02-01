# Claude Plugins

A small collection of plugins and skills for Claude Code.

## Repository layout

```
plugins/
  <plugin>/
    .claude-plugin/      # Plugin metadata
    commands/            # /plugin:command handlers
    hooks/               # Optional lifecycle hooks
    skills/              # Optional reusable skills
    README.md            # Plugin-specific docs
```

## Installation

Install all published plugins from this repo:

```bash
/plugin install @misfitdev
```

Install a single plugin by name:

```bash
/plugin install <plugin>@misfitdev
```

## Documentation

Each plugin has its own README in `plugins/<plugin>/README.md`.

## License

MIT
