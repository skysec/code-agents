---
description: "Fetches GitHub issue information, analyzes requirements, and assigns tasks to appropriate sub-agents for implementation."
argument-hint: [owner] [repo] [issue-id]
allowed-tools: ["Task", "Read", "Write", "Edit", "MultiEdit", "Grep", "Glob", "TodoWrite", "mcp__github_mcp__get_issue", "mcp__github_mcp__get_issue_comments", "mcp__github_mcp__list_sub_issues"]
---

# GitHub Issue Implementation Orchestrator

## Description
Fetches comprehensive GitHub issue information including parent issues and sub-issues, analyzes the requirements, validates completeness, and assigns the task to the most appropriate sub-agent for implementation.

## Usage
```
/issue-implementation <owner> <repo> <issue-id>
```

## Parameters
- `owner`: GitHub repository owner (username or organization)
- `repo`: Repository name
- `issue-id`: Issue number to analyze and implement

## Example
```
/issue-implementation anthropics claude-code 123
```

## Workflow
This command performs the following steps:

1. **Issue Fetching** - Retrieves issue details, comments, and related issues
2. **Relationship Analysis** - Identifies parent issues and sub-issues
3. **Requirement Assessment** - Validates if sufficient information exists for implementation
4. **Sub-Agent Selection** - Chooses the most appropriate specialist agent
5. **Context Generation** - Creates detailed context file for the selected agent
6. **Task Assignment** - Delegates implementation to the chosen sub-agent

## Available Sub-Agents
- **product-manager**: For requirement analysis and specification
- **system-architect**: For system design and architecture decisions
- **project-manager**: For task breakdown and project planning
- **senior-code-reviewer**: For code review and quality assessment
- **security-code-reviewer**: For security-focused code analysis
- **terraform-infrastructure-specialist**: For infrastructure and deployment tasks

## Command Implementation

Starting GitHub Issue Implementation Analysis...

**Repository**: $1/$2
**Issue ID**: $3

### Phase 1: Issue Data Retrieval

Fetching comprehensive issue information using GitHub MCP Server:
- Main issue details and description
- All issue comments and discussions
- Parent issue relationships (if any)
- Sub-issue listings and dependencies
- Issue labels, assignees, and metadata

### Phase 2: Requirement Analysis

Analyzing retrieved information to:
- Extract technical requirements
- Identify implementation scope
- Assess complexity level
- Determine required expertise areas
- Validate information completeness

### Phase 3: Sub-Agent Selection

Selecting optimal sub-agent based on:
- Issue type and labels
- Technical complexity
- Required skill domains
- Implementation scope

**Selection Criteria:**
- **Infrastructure/DevOps issues** → terraform-infrastructure-specialist
- **Security-related issues** → security-code-reviewer  
- **Code review requests** → senior-code-reviewer
- **Feature specification needs** → product-manager
- **System design requirements** → system-architect
- **Project planning needs** → project-manager

### Phase 4: Context Documentation

Creating `.claude/context/{issue-id}_task.md` with:
- Complete issue analysis
- Technical requirements summary
- Implementation guidelines
- Related issues context
- Recommended approach

### Phase 5: Task Assignment

Delegating to selected sub-agent with full context and clear objectives.

## Expected Output Structure

```
.claude/
├── context/
│   └── {issue-id}_task.md    # Comprehensive task context
```

## Execute Workflow

I'll now fetch and analyze the GitHub issue to create a comprehensive implementation plan.

### Step 1: Fetching Issue Information

Using GitHub MCP Server to retrieve:
- Issue details and description  
- Comments and discussions
- Sub-issues and parent relationships
- Labels and metadata

### Step 2: Analyzing Requirements  

I'll assess the issue to determine:
- Technical complexity and scope
- Required implementation expertise
- Information completeness
- Best-suited sub-agent

### Step 3: Selecting Sub-Agent

Based on issue analysis, I'll choose from available specialists:
- terraform-infrastructure-specialist (infrastructure/DevOps)
- security-code-reviewer (security-focused tasks)  
- senior-code-reviewer (code review/quality)
- system-architect (system design)
- product-manager (requirements/specs)
- project-manager (planning/coordination)

### Step 4: Creating Context Documentation

I'll generate `.claude/context/{issue-id}_task.md` containing:
- Complete issue analysis
- Technical requirements
- Implementation approach
- Related context

### Step 5: Task Assignment  

Finally, I'll delegate to the selected sub-agent with full context for implementation.