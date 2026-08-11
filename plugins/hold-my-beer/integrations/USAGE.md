# Hold My Beer: Cross-Platform Usage Guide

Hold My Beer has native plugin adapters for Claude Code and Codex. Its canonical workflow is also
portable as a system prompt for other capable models and AI-enhanced editors.

## 1. Native plugin hosts

- **Claude Code:** install `hold-my-beer@misfitdev-plugins`, then invoke `/hold-my-beer:hmb`.
- **Codex:** install `hold-my-beer@misfitdev-plugins`, then invoke `$hold-my-beer`.

## 2. Using with Cursor (VS Code Fork)

1. Copy `integrations/cursor.rules` to the **root** of your project.
2. Rename it to `.cursorrules`.
3. **Usage:** When you chat with Cursor (Cmd+L) or use Composer (Cmd+I), describe a risky change and the AI will produce a structured HMB execution plan.

## 3. Using with Gemini (AI Studio / Web) & ChatGPT

1. Open `integrations/system-prompt.md`.
2. Copy the entire content.
3. **Gemini / ChatGPT:** Paste it as the first message in a new chat.
   - *Tip:* In **Google AI Studio** or **OpenAI Playground**, paste into the "System Instructions" or "System" box.
4. **Usage:** Describe your risky idea. The model will produce the 9-section plan with verdict.

## 4. Using with GitHub Copilot

**Option A: Copilot Chat**
Paste the text from `integrations/system-prompt.md` into the chat window and say: *"Adopt this persona for the rest of this session."*

**Option B: In-File Instruction**
Add a comment at the top of a deployment script or runbook:

```bash
# INSTRUCTION: Review this deployment plan using the "Hold My Beer" methodology.
# Produce a 9-section plan with tripwires, rollback, and a GO/NO-GO verdict.
```

## Summary of Files

| File | Purpose |
| :--- | :--- |
| `cursor.rules` | Rename to `.cursorrules` in your project root for Cursor integration. |
| `system-prompt.md` | Copy/paste into any LLM (Gemini, GPT) to start an HMB session. |
| `USAGE.md` | This file. |
