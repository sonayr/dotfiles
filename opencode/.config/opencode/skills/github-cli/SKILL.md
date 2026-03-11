---
name: github-cli
description: Instructions on how to use the github cli tool
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: github
---
## What I do
- I provide a guide on how to use the github cli tool
- I explain how to work with repositories
- I explain how to work with issues
- I explain how to create PR Reviews

## When to use me
Use this when you need to perform github actions from the command line.

## How to use me
The following are examples of how to use the github cli tool.

### Create a pull request
gh pr create --title "The PR title" --body "The PR body"

### View pull request status
gh pr status

### Checkout a pull request
gh pr checkout <pr-number>

### Create a repository
gh repo create <repo-name> --public

### View repository
gh repo view <repo-name>

### Create an issue
gh issue create --title "The issue title" --body "The issue body"

### List issues
gh issue list

### Create a pull request review
gh pr review <pr-number> --approve
gh pr review <pr-number> --request-changes -b "This needs more work"

### View pull request reviews
gh pr review <pr-number>
