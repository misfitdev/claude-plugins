# Claude Plugins

Custom plugins and skills for [Claude Code](https://claude.ai/code).

## Installation

```bash
/plugin install @misfitdev
```

## Plugins

### frank-grimes

A pessimistic iteration loop for systematically destroying, rebuilding, and hardening ideas. Named after Frank Grimes from The Simpsons - the guy who actually analyzed what was wrong and refused to let it slide.

**Philosophy:** Everything is crap until proven otherwise.

```bash
/plugin install frank-grimes@misfitdev
```

**Commands:**
| Command | Description |
|---------|-------------|
| `/frank-grimes:grind <target>` | Start a Grimes Grind on code, architecture, or ideas |
| `/frank-grimes:cancel` | Cancel an active grind loop |
| `/frank-grimes:help` | Show help and usage information |

**Options:**
- `--max-iterations N` - Stop after N iterations (default: 5)
- `--auto-loop` - Keep iterating until GREEN verdict

**Examples:**
```bash
/frank-grimes:grind ./src/auth.py
/frank-grimes:grind this --auto-loop
/frank-grimes:grind "our plan to use MongoDB for transactions" --max-iterations 10
```

[Full documentation](plugins/frank-grimes/README.md)

## Structure

```
plugins/
└── frank-grimes/                 # Pessimistic iteration loop
    ├── commands/
    │   └── frank-grimes/         # /frank-grimes:grind, :cancel, :help
    ├── hooks/                    # Auto-loop stop hook
    └── skills/
        └── frank-grimes/         # The Grimes Grind methodology
```

## License

MIT
