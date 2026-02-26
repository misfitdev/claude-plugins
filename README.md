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

Add this repo as a marketplace (one-time setup):

```
/plugin marketplace add misfitdev/claude-plugins
```

Then install any plugin by name:

```
/plugin install hold-my-beer@misfitdev/claude-plugins
/plugin install frank-grimes@misfitdev/claude-plugins
/plugin install conductor@misfitdev/claude-plugins
```

## Documentation

Each plugin has its own README in `plugins/<plugin>/README.md`.

## License

MIT
