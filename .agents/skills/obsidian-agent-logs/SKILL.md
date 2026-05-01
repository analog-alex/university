---
name: obsidian-agent-logs
description: Create or append daily agent activity logs in a local Obsidian vault using clean Markdown. Use this whenever the user asks to log agent work, write an agent journal, append a run summary, maintain per-day notes, or update an Obsidian-based activity log.
---

# Obsidian Agent Logs

Write brief, readable daily logs for both humans and agents in a local Obsidian vault.

## Leverage Obsidian Markdown

- Follow `obsidian-markdown` conventions for valid Obsidian-flavored syntax.
- Keep entries simple Markdown by default; only add Obsidian extras (tags, wikilinks, callouts) when the user asks.

## Target Location

- Vault folder: `/Users/miguelalexandre/Documents/knowledge-base/Agents Logs`
- One file per day, named `YYYY-MM-DD.md` (example: `2026-05-01.md`)

## Required Behavior

1. Determine today's local date and compute the daily file path.
2. If the daily file does not exist, create it.
3. Append each new log entry at the end of that file.
4. Keep entries short and clear: 2-5 lines of plain language.
5. Always end each log entry with a horizontal rule: `---`.

## Entry Format

Always use this exact structure for each appended entry:

```markdown
# {Example Log - I am agent and I did}

{example of text}
{example of text}
{example of text}
---
```

## Writing Guidelines

- Use concise Markdown that is easy to scan.
- Describe what was done and why it mattered.
- Prefer concrete actions over vague wording.
- Do not include sensitive secrets.
- Add a blank line between entries when appending to an existing file.

## Output Contract

After writing, report:

1. The file path that was updated.
2. The heading used for the new entry.
3. A one-line confirmation that the entry was appended.
