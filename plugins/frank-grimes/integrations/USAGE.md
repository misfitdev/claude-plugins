# Frank Grimes: Cross-Platform Usage Guide

The "Frank Grimes" (or Grimey) persona is designed for Disciplined Falsification Reviews. While originally built as a Claude plugin, its core is a rigorous system prompt that can be used with any capable LLM (Gemini, Codex/GPT-4, etc.) or AI-enhanced editor (Cursor).

## 1. Using with Cursor (VS Code Fork)

Cursor allows you to define project-specific rules for its AI.

1.  Copy the file `integrations/cursor.rules` to the **root** of your project.
2.  Rename it to `.cursorrules`.
3.  **Usage:** When you chat with Cursor (Cmd+L) or use Composer (Cmd+I), the AI will automatically adopt the Frank Grimes persona. It will be more critical, look for bugs proactively, and avoid "slop" code generation.

## 2. Using with Gemini (AI Studio / Web) & ChatGPT

You can use the standalone system prompt to "prime" a chat session.

1.  Open `integrations/system-prompt.md`.
2.  Copy the entire content.
3.  **Gemini / ChatGPT:** Paste it as the very first message in a new chat.
    *   *Tip:* In **Google AI Studio** or **OpenAI Playground**, paste this into the "System Instructions" or "System" box for a persistent effect throughout the session.
4.  **Usage:** Once primed, paste your code or architecture plan. The model will critique it using the Grimes methodology.

## 3. Using with GitHub Copilot (Codex)

Copilot is harder to "mode switch," but you can use comments or chat instructions.

**Option A: Copilot Chat**
Paste the text from `integrations/system-prompt.md` into the chat window and say: *"Adopt this persona for the rest of this session."*

**Option B: In-File Instruction**
At the top of a file you want reviewed, add this comment:

```javascript
// INSTRUCTION: Review this code using the "Frank Grimes" methodology.
// Assume it is broken. Look for: Security flaws, Happy-path only logic, and Silent failures.
// Be critical and direct.
```

## Summary of Files

| File | Purpose |
| :--- | :--- |
| `cursor.rules` | Rename to `.cursorrules` in your project root for Cursor integration. |
| `system-prompt.md` | Copy/paste this into any LLM (Gemini, GPT) to start a Grimey session. |
| `USAGE.md` | This file. |
