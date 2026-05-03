---description: Automate the workflow for a Linear issue from implementation to PR, including issue status updates, tests, and PR linking.agent: general---
Automate a complete development workflow from a Linear issue to an opened pull request for issue $ARGUMENTS.

## Workflow Overview

1. Fetch Linear issue details using Linear MCP
2. Analyze requirements and create an implementation plan
3. Ensure repository is on `main` and up to date
4. Create a feature branch with a clear issue-based name
5. Update Linear issue status to "In Progress"
6. Implement required changes
7. Add or update tests where appropriate
8. Commit with a descriptive message referencing the issue
9. Open a PR via GitHub CLI with the Linear issue link
10. Add PR link as a comment on the Linear issue

## Instructions

### 1) Fetch issue details

Use Linear MCP to get:
- issue title and description
- labels/status
- acceptance criteria and constraints

### 2) Analyze and plan

Before coding:
- identify files to modify
- decide test scope
- choose an implementation approach

If requirements are unclear, ask one focused clarification question.

### 3) Prepare repository

Run these commands:
```bash
git branch --show-current
git checkout main
git pull origin main
git status
```

### 4) Create feature branch

Branch naming convention:

```
<ISSUE-ID>/<short-description>
```

Examples:
- `ENG-123/add-user-authentication`
- `PROJ-456/fix-payment-validation`

Run:
```bash
git checkout -b $ARGUMENTS/<short-description>
```

### 5) Update Linear status

If the issue is not already in progress or later, update it to `In Progress`.

### 6) Implement changes

- follow project conventions and existing patterns
- keep changes focused and maintainable
- add error handling where needed

### 7) Add tests

Default to adding/updating tests for:
- new features
- bug fixes
- business logic changes

Skip only for docs-only or non-functional cosmetic/config changes.

### 8) Commit changes

Use conventional commit style and reference the issue:

```bash
git add .
git commit -m "<type>: <brief summary>

Linear Issue: $ARGUMENTS"
```

Use `feat`, `fix`, `refactor`, `test`, `docs`, or `chore` as appropriate.

### 9) Push and create PR

```bash
git push origin <branch-name>
gh pr create \
  --title "[$ARGUMENTS] | <brief description>" \
  --body "## Description
<summary>

## Changes
- <change 1>
- <change 2>

## Testing
<how tested>

## Linear Issue
Closes <LINEAR-ISSUE-URL>" \
  --base main
```

### 10) Comment back on Linear

After PR creation, add a comment to the Linear issue with the PR URL.

## Best Practices

- keep branch names short and issue-linked
- explain the "why" in commit/PR text
- keep PR descriptions reviewer-friendly
- include screenshots for UI changes
- PR name should be [LINEAR-TICKET] | <task description>

## Error handling

If a step fails:
1. report the error clearly
2. suggest a concrete fix
3. stop progression until resolved

## Requirements

- git repository initialized
- `gh` installed and authenticated
- Linear MCP configured and authenticated
- repository default flow based on `main`
