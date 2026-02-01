# Grimes Grind Plugin

> "I've had to work hard every day of my life, and what do I have to show for it? This briefcase, and this haircut."
> — Frank Grimes

A pessimistic iteration loop for systematically destroying, rebuilding, and hardening ideas. Named after Frank Grimes ("Grimey") from The Simpsons - the only character who actually *analyzed* what was wrong and refused to let it slide.

## Philosophy

**Everything is crap until proven otherwise.**

The Grimes Grind assumes your idea, code, plan, or design is:
- LLM slop
- Unreliable
- Insecure
- Poorly planned
- Not production-ready
- Unmaintainable

Your job is to prove these assumptions WRONG, not to prove the idea right.

## Installation

Clone the repository and copy the plugin to your plugins directory:

```bash
git clone https://github.com/misfitdev/claude-plugins.git
cp -r claude-plugins/plugins/frank-grimes ~/.claude/plugins/
```

## Commands

### `/frank-grimes:grind <target> [--max-iterations N] [--auto-loop] [--with-api-review]`

Start a Grimes Grind on the specified target.

**Arguments:**
- `target` (required): What to grind - file path, description, or "this" for current context
- `--max-iterations N`: Maximum iterations before stopping (default: 5)
- `--auto-loop`: Enable automatic iteration until GREEN verdict
- `--with-api-review`: Enable Phase 2 API Correctness & Completeness review (default: false)

**Examples:**

```bash
# One-shot grind on a file (Phase 1: Runtime Reliability only)
/frank-grimes:grind ./src/auth.py

# Grind with API review enabled (Phase 1 + Phase 2)
/frank-grimes:grind ./src/api --with-api-review

# Auto-loop with both phases until GREEN
/frank-grimes:grind ./proto-mcp --with-api-review --auto-loop

# Red team an architecture proposal
/frank-grimes:grind "The proposal to use MongoDB for our financial transaction system"
```

### `/frank-grimes:cancel`

Cancel an active Grimes Grind loop and report final status.

### `/frank-grimes:help`

Display help and usage information for the Grimes Grind plugin.

## How It Works

### The Grimes Grind Process

1. **Phase 1: The Grimey Read** - Understand what you're critiquing (max 3 clarifying questions)
2. **Phase 2: Default Assumptions** - Assume it's broken in every way
3. **Phase 3: The Grind** - Systematically attack across 17 categories
4. **Phase 4: The Rebuild** - Propose fixes with regression scope
5. **Phase 5: Re-Grind (Scoped)** - Verify fixes didn't introduce new problems
6. **Phase 6: Stop Conditions** - Determine verdict

### Verdicts

| Verdict | Meaning |
|---------|---------|
| 🟢 **GREEN** | All P0 mitigated, P1 planned, verification exists, observability sufficient |
| 🟡 **YELLOW** | P0 mitigated but P1 weak, partial verification, needs monitoring |
| 🔴 **RED** | P0 unmitigated, no verification, blocking issues remain |

### Auto-Loop Behavior

When `--auto-loop` is enabled:
1. The stop hook intercepts exit attempts
2. If verdict is not GREEN and iterations remain, the grind continues
3. State is persisted in `.grimes-state.json`
4. Loop exits when GREEN or max iterations reached

## Phase Structure

### Phase 1: Runtime Reliability & Production Blocking (Always Active)

Focuses on P0/P1 defects that would prevent production deployment:
- Syntax errors, compilation failures
- Unhandled errors in critical paths
- Resource leaks (timeouts, cleanup, OOM)
- Security issues (credentials, injection, auth)

**Verdict:** GREEN/YELLOW/RED based on blocking issues

**Output:** GRIMES_REPORT.md with risk register, fixes, and deployment checklist

---

### Phase 2: API Correctness & Completeness (Optional, --with-api-review)

Focuses on P1/P2 API quality issues:
- Package path correctness (`go_package`, Python imports)
- Feature completeness (no unfinished TODOs in production)
- Public interface documentation (godoc, docstrings)
- API consistency (error returns, naming patterns)
- Language best practices (no bare except, idiomatic code)

**Verdict:** API Quality Score (0-100) + categorized findings

**Output:** API_QUALITY_REPORT.md with score breakdown and technical debt backlog

**When to use Phase 2:**
- After Phase 1 is GREEN (API quality doesn't block production)
- When scheduling technical debt sprints
- For comprehensive code quality assessment
- When handoff to different team requires API documentation

---

## Critique Categories

The grind checks across these dimensions:

### Core Categories (v1.0+)

| Category | Focus |
|----------|-------|
| LLM Slop Check | Hallucinated APIs, cargo-culting, confident nonsense |
| Correctness | Does it actually work? Invariants enforced? |
| Reliability | Failure handling, retries, timeouts |
| Security | Input validation, auth, secrets, injection |
| Error Handling | Caught, logged, surfaced, or swallowed? |
| Edge Cases | Null, empty, unicode, timezones, leap seconds |
| Scalability | 10x? 100x? Where's the bottleneck? |
| Observability | Metrics, logs, traces, alerts |
| Testability | Tests exist? Test the right things? |
| Maintainability | Understandable in 6 months? |
| Dependencies | Reliable? Maintained? Upgrade path? |
| Deployment | Rollback? Feature flags? YOLO push? |
| Privacy & Data | PII, retention, GDPR |
| Compliance | Audit logs, SOC 2, domain-specific |
| Cost | Run cost, maintenance burden |
| Human Factors | Will people use it correctly? |
| Failure Modes | How does it die? Blast radius? |

### Enhanced Categories (v2.0+)

| Category | Focus |
|----------|-------|
| Code Quality & Formatting | Syntax errors, malformed code, unused imports, dead code |
| Code Duplication | Repeated logic, constants in multiple places, DRY violations |
| Input Validation | User input validated before use? Injection vectors? Bypass paths? |
| Language-Specific Patterns | Go goroutines/channels, Python exceptions, TypeScript types |
| Configuration Management | Hard-coded values, inconsistencies, secret management |
| Resource Lifecycle | Files, connections, memory properly released on error paths |

---

## Enhanced Critique Categories (v2.0+)

The grind now detects code-quality and structural issues missed in earlier versions.

### Code Quality & Formatting

Detects syntactically malformed or structurally problematic code:
- Syntax errors that would prevent compilation/execution
- Unused imports or variables
- Unreachable code paths
- Malformed control flow

**Why it matters:** Code that doesn't even parse is obviously wrong, but can be subtle in dynamic languages.

**Example:** Go file with missing import statement; Python with incorrect except syntax.

### Code Duplication

Identifies logic and constants repeated across the codebase:
- Magic numbers (timeouts, limits) in multiple files
- Same validation logic in multiple functions
- Configuration values that should be centralized
- Business logic duplicated across implementations

**Why it matters:** When duplicated code needs to change, you must change it EVERYWHERE. If you miss one, you have a bug.

**Example:** `30 * time.Second` timeout in Go and `DEFAULT_REQUEST_TIMEOUT = 30` in Python instead of a shared config.

### Input Validation

Ensures all user-controlled input is validated before use:
- Where does input come from? (CLI args, API params, file content)
- Where is it validated?
- Can validation be bypassed?
- Are there injection vectors? (SQL, command, path traversal)

**Why it matters:** Every major security breach involves unvalidated input.

**Example:** Tool name passed directly to function call without regex validation.

### Language-Specific Patterns

Catches anti-patterns and gotchas specific to each language:

**Go patterns:**
- Goroutine leaks (spawned but never joined)
- Channel misuse (created but never closed)
- Nil dereferences and missing nil checks
- defer in loops (memory leak)
- sync.Mutex without defer unlock

**Python patterns:**
- Bare `except:` clause that catches Ctrl-C
- Mutable default arguments
- Missing context manager cleanup
- Generator functions with side effects
- pickle.loads() with untrusted data

**TypeScript/JavaScript patterns:**
- `any` type (disables type safety)
- Unhandled Promise rejections
- Missing null checks
- async without await or catch

**Why it matters:** Each language has hidden traps that experienced developers know to avoid.

**Example:** Python bare `except:` clause that catches Ctrl-C (KeyboardInterrupt) instead of just the intended exception.

### Configuration Management

Identifies hard-coded values that should be configurable:
- Magic numbers without explanation
- URLs, ports, hostnames as literals
- API endpoints in code instead of config
- Secrets in version control
- Inconsistent values across implementations

**Why it matters:** Hard-coded values make code inflexible and brittle. Every production incident starts with "we need to change X without redeploying."

**Example:** Timeout values hard-coded in handler code instead of in a config package.

### Resource Lifecycle

Ensures resources are properly acquired and released:
- File handles, sockets, database connections
- Memory allocations with bounds
- Context cancellation
- Cleanup in error paths
- Dangling goroutines or threads

**Why it matters:** Resource leaks cause production outages. Error paths are where leaks happen most.

**Example:** Go file opened with `os.Open` but `defer close()` missing; Python socket created without `try/finally`.

## Output: The Grimes Report

Every grind produces a structured report:

```markdown
## Grimes Grind Report: [Subject]

### Verdict: 🟢 GREEN | 🟡 YELLOW | 🔴 RED

**Top 3 Risks:**
1. ...
2. ...
3. ...

### Risk Register
| ID | Category | Risk Statement | Severity | Likelihood | Blast Radius | Evidence | Status |
...

### Can't Prove Wrong (Survived Scrutiny)
| Claim | Supporting Evidence | What Would Falsify It |
...

### Grimey's Final Word
[One brutal sentence of truth]
```

## Multi-Language Project Handling (v2.0+)

When grinding a polyglot project (Go + Python, TypeScript + Python, etc.), the process now:

1. **Pre-Phase-1: Inventories all languages** and maps configuration sources
2. **Phase 1: Asks explicit cross-language questions** about configuration and error handling consistency
3. **Phase 3: Checks each language** against language-specific patterns and anti-patterns
4. **Phase 3: Flags inconsistencies** (e.g., different timeout values, different validation patterns)
5. **Phase 3: Identifies duplication** across language boundaries (config values, logic)

This prevents the "Go code looks fine, but Python has a gotcha" scenario.

### Example: Proto-MCP Project (Go + Python)

Running Grimes v2.0+ on a project with Go and Python would catch:

- **Code Quality**: Malformed `client.go` code with excessive blank lines (grime-fmt-*)
- **Code Duplication**: Timeout value `30 * time.Second` in Go but `DEFAULT_REQUEST_TIMEOUT = 30` in Python (grime-dup-*)
- **Language-Specific**: Bare `except:` in Python registry (grime-lang-py-*)
- **Input Validation**: Missing tool name validation in binary handler (grime-val-*)
- **Configuration**: Hard-coded defaults not centralized (grime-cfg-*)
- **Resource Lifecycle**: Python gRPC client missing context manager cleanup (grime-res-*)

v1.0 caught only behavioral correctness issues; v2.0+ catches structural and quality issues across language boundaries.

## Dependencies

- `jq` - Required for the stop hook to parse state JSON

Install on macOS: `brew install jq`
Install on Ubuntu: `apt-get install jq`

## Anti-Patterns

The skill warns against these failure modes:

- **Grimey Theater**: Going through motions without genuine skepticism
- **Optimism Creep**: "It'll probably be fine" - NO. Prove it.
- **Authority Deference**: "The LLM said so" - Verify anyway.
- **Perfection Paralysis**: Never shipping because something might be wrong
- **Orphaned Risks**: Accepted risks with no owner

## Credits

- Methodology inspired by pre-mortems, red teaming, and threat modeling
- Loop technique inspired by similar pessimistic iteration approaches
- Named after Frank Grimes from The Simpsons, S8E23 "Homer's Enemy"

---

*"You know what makes me mad? Not just that this is broken - it's that someone shipped it thinking it was fine. That's the real failure."*
— The Spirit of Grimey
