#!/bin/bash
#
# Hold My Beer Stop Hook
#
# Intercepts Claude's exit attempts during an active HMB refinement loop.
# If a plan refinement is in progress and verdict warrants iteration,
# it re-injects the prompt to continue refining.
#

set -euo pipefail

CACHE_DIR="${HOME}/.cache/claude-plugins/hold-my-beer"
LOG_FILE="${CACHE_DIR}/hook.log"
STATE_FILE="${CACHE_DIR}/sessions/hmb-state.json"
STATE_DIR="${CACHE_DIR}/sessions"

mkdir -p "$STATE_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

if ! command -v jq &> /dev/null; then
    log "ERROR: jq not found. Auto-loop requires jq."
    echo "ERROR: jq is required for auto-loop. Install with: brew install jq (macOS) or apt-get install jq (Linux)" >&2
    exit 0
fi

if [[ ! -f "$STATE_FILE" ]]; then
    log "No active HMB state found"
    exit 0
fi

if ! jq empty "$STATE_FILE" 2>/dev/null; then
    log "ERROR: Corrupted state file at $STATE_FILE"
    echo "WARNING: State file appears corrupted. Removing." >&2
    rm -f "$STATE_FILE"
    exit 0
fi

for field in iteration max_iterations last_verdict idea auto_loop; do
    if ! jq -e ".$field" "$STATE_FILE" &>/dev/null; then
        log "ERROR: State file missing required field: $field"
        echo "WARNING: State file incomplete. Removing." >&2
        rm -f "$STATE_FILE"
        exit 0
    fi
done

STATE=$(cat "$STATE_FILE")
ITERATION=$(echo "$STATE" | jq -r '.iteration // 0')
MAX_ITERATIONS=$(echo "$STATE" | jq -r '.max_iterations // 3')
LAST_VERDICT=$(echo "$STATE" | jq -r '.last_verdict // "NO_GO"')
IDEA=$(echo "$STATE" | jq -r '.idea // ""')
AUTO_LOOP=$(echo "$STATE" | jq -r '.auto_loop // false')

if ! [[ "$ITERATION" =~ ^[0-9]+$ ]] || [[ "$ITERATION" -eq 0 ]]; then
    log "ERROR: iteration is not a valid positive integer: $ITERATION"
    rm -f "$STATE_FILE"
    exit 0
fi

if ! [[ "$MAX_ITERATIONS" =~ ^[0-9]+$ ]] || [[ "$MAX_ITERATIONS" -eq 0 ]]; then
    log "ERROR: max_iterations is not a valid positive integer: $MAX_ITERATIONS"
    rm -f "$STATE_FILE"
    exit 0
fi

if [[ ! "$LAST_VERDICT" =~ ^(GO|GO_WITH_CONSTRAINTS|NO_GO)$ ]]; then
    log "ERROR: Invalid verdict '$LAST_VERDICT'. Treating as NO_GO."
    LAST_VERDICT="NO_GO"
fi

log "Hook invoked: iteration=$ITERATION/$MAX_ITERATIONS, verdict=$LAST_VERDICT, auto_loop=$AUTO_LOOP"

if [[ "$AUTO_LOOP" != "true" ]]; then
    log "Auto-loop disabled, allowing exit"
    exit 0
fi

if [[ "$LAST_VERDICT" == "GO" ]]; then
    log "Verdict is GO. Plan is solid. Allowing exit."
    echo "HMB plan complete. Verdict: GO. You're good to go."
    rm -f "$STATE_FILE"
    exit 0
fi

if [[ "$ITERATION" -ge "$MAX_ITERATIONS" ]]; then
    log "Max iterations ($MAX_ITERATIONS) reached with verdict $LAST_VERDICT. Allowing exit."
    echo "HMB: Max iterations ($MAX_ITERATIONS) reached. Final verdict: $LAST_VERDICT"
    rm -f "$STATE_FILE"
    exit 0
fi

log "Loop continuation conditions met. Blocking exit."
NEXT_ITERATION=$((ITERATION + 1))

if ! echo "$STATE" | jq ".iteration = $NEXT_ITERATION" > "$STATE_FILE.tmp"; then
    log "ERROR: Failed to update state file"
    rm -f "$STATE_FILE.tmp"
    exit 0
fi
mv "$STATE_FILE.tmp" "$STATE_FILE"

echo "HMB: Iteration $NEXT_ITERATION of $MAX_ITERATIONS. Last verdict: $LAST_VERDICT. Refining plan..."

cat << EOF
Hold My Beer: Refine Execution Plan

Idea: $IDEA
Iteration: $NEXT_ITERATION of $MAX_ITERATIONS
Previous Verdict: $LAST_VERDICT

The previous iteration did not achieve a GO verdict. You are required to:

1. Review the previous plan and identify what blocked a GO verdict.
2. Address each constraint or blocker specifically.
3. If the verdict was NO-GO, determine if the blockers can be resolved or if the plan needs restructuring.
4. If the verdict was GO-WITH-CONSTRAINTS, tighten the plan to remove constraints where possible.
5. Re-evaluate all 9 sections and update the verdict.

**CRITICAL STATE FILE REQUIREMENT:**
You MUST update ~/.cache/claude-plugins/hold-my-beer/sessions/hmb-state.json after determining your verdict:
- Set last_verdict to your new verdict (GO, GO_WITH_CONSTRAINTS, or NO_GO)
- Set stages and tripwires counts
- DO NOT change the iteration number (the hook manages that)
- Use the Write tool to persist changes

Produce the complete updated HMB plan with all 9 sections.
EOF

exit 2
