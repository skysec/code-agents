---
description: "Orchestrates a complete product design workflow using specialized agents to create requirements, architecture design, and implementation tasks."
argument-hint: [feature-name] [description]
allowed-tools: ["Task", "Read", "Write", "Edit", "MultiEdit", "Grep", "Glob", "TodoWrite"]
---

# Product Design Orchestration

## Description
Orchestrates a complete product design workflow using specialized agents to create requirements, architecture design, and implementation tasks.

## Usage
```
/product-design <feature_name> "<description>"
```

## Parameters
- `feature_name`: Name of the feature or product to be designed
- `description`: Detailed description of the feature requirements and goals

## Example
```
/product-design user-authentication "Implement secure user authentication system with email verification, password reset, and multi-factor authentication support"
```

## Workflow
This command orchestrates three specialized agents in sequence:

1. **Product Manager Agent** - Creates comprehensive product requirements
2. **System Architect Agent** - Designs system architecture and technical specifications  
3. **Project Manager Agent** - Breaks down the design into actionable implementation tasks

## Command Implementation
```bash
#!/bin/bash

FEATURE_NAME="$1"
DESCRIPTION="$2"

if [ -z "$FEATURE_NAME" ] || [ -z "$DESCRIPTION" ]; then
    echo "Usage: /product-design <feature_name> \"<description>\""
    echo "Example: /product-design user-auth \"Implement secure user authentication\""
    exit 1
fi

echo "🎯 Starting Product Design Orchestration for: $FEATURE_NAME"
echo "📋 Description: $DESCRIPTION"
echo ""
```
## Sub-Agent Chain Process

Execute the following chain using Claude Code's sub-agent syntax:

```
First use the Product Manager agent to generate complete specifications for [$FEATURE_NAME,$DESCRIPTIO], then use the System Architect Agent to design system architecture, then use the Project Manager Agent to to create the project plan, with tasks, sub-tasks and definition of done.
```

## Workflow Logic


### Chain Execution Steps

1. **product-manager agent**: Generate docs/requirements.md
2. **system-architect Agent**: Create docs/architecture.md
3. **project-manager agent**: Create docs/tasks.md

## Execute Workflow

**Feature Name**: $FEATURE_NAME
**Feature Description**: $DESCRIPTION

Starting automated Product Design Orchastration Workflow...

### Phase 1: Requirements Generation

First use the **product-manager**  agent to analyze requirements and generate:
- Detailed requirements documentation
- User stories with acceptance criteria
- Technical constraints and assumptions

### Phase 2: Architecture Design

Then use the **system-architect**  agent to create:
- System architecture design
- API specifications and contracts
- Technology stack decisions
- Database schema and data flow
- Security and performance considerations

### Phase 3: Project Plan

Then use the **project-manager** sub agent to:
- Review architecture and requirements
- Identify all feature components
- Map dependencies
- Break features into 4-8 hour tasks
- Write clear acceptance criteria

## Expected Output Structure

```
project/
├── docs/
│   ├── requirements.md
│   ├── architecture.md
│   ├── tasks.md
```