# Claude Code Marketplace Specification

This document explains how this repository implements the official Claude Code marketplace specification.

## Overview

This repository is a **Claude Code-compatible marketplace** that follows Anthropic's official plugin and marketplace specification. It can be used natively within Claude Code or distributed as a standalone collection.

## Official Specification Compliance

### 1. Plugin Manifest (`.claude-plugin/plugin.json`)

**Location:** `.claude-plugin/plugin.json`

**Purpose:** Defines the plugin metadata for Claude Code's native plugin system.

**Our Implementation:**
```json
{
  "name": "specialized-agents",
  "version": "1.0.0",
  "description": "A curated collection of specialized AI agents for software development workflows",
  "author": {
    "name": "Code Agents Team",
    "url": "https://github.com/skysec/code-agents"
  },
  "homepage": "https://github.com/skysec/code-agents",
  "repository": "https://github.com/skysec/code-agents",
  "license": "MIT",
  "keywords": [
    "agents", "development", "security",
    "infrastructure", "code-review", "planning", "architecture"
  ],
  "agents": ".claude/agents/",
  "commands": ".claude/commands/"
}
```

**Required Fields:**
- `name` (required) - Plugin identifier in kebab-case
- `agents` (optional) - Path to agents directory
- `commands` (optional) - Path to commands directory

**Recommended Fields:**
- `version` - Semantic version (MAJOR.MINOR.PATCH)
- `description` - Brief explanation of plugin purpose
- `author` - Creator information
- `homepage` - Documentation URL
- `repository` - Source code location
- `license` - License identifier
- `keywords` - Searchable tags

### 2. Marketplace Definition (`.claude-plugin/marketplace.json`)

**Location:** `.claude-plugin/marketplace.json`

**Purpose:** Enables distribution of plugin collections.

**Our Implementation:**
```json
{
  "$schema": "https://anthropic.com/claude-code/marketplace.schema.json",
  "name": "specialized-agents-marketplace",
  "version": "1.0.0",
  "description": "Claude Code Agent Marketplace - Specialized agents for software development",
  "owner": {
    "name": "Code Agents Team",
    "email": "code-agents@example.com",
    "url": "https://github.com/skysec/code-agents"
  },
  "plugins": [
    {
      "name": "specialized-agents",
      "source": ".",
      "description": "Collection of specialized agents",
      "version": "1.0.0",
      "category": "development",
      "agents": [ /* list of 7 agents */ ],
      "commands": [ /* list of 2 commands */ ]
    }
  ],
  "categories": {
    "planning": { /* metadata */ },
    "design": { /* metadata */ },
    "quality": { /* metadata */ },
    "security": { /* metadata */ },
    "infrastructure": { /* metadata */ }
  }
}
```

**Key Features:**
- Lists all plugins in the marketplace
- Defines custom categories
- Includes agent and command metadata
- Supports multiple plugins in one marketplace

### 3. Agent Definitions

**Location:** `.claude/agents/*.md`

**Format:** Markdown files with YAML frontmatter

**Example:**
```markdown
---
name: security-code-reviewer
description: Review code for security vulnerabilities using OWASP framework
tools: Glob, Grep, Read, WebFetch, TodoWrite, WebSearch, Bash
color: red
model: inherit
---

You are a security code reviewer specializing in OWASP vulnerabilities...
```

**Required YAML Fields:**
- `name` - Agent identifier (matches filename)
- `description` - When and why to use this agent
- `tools` - Comma-separated list of available tools

**Optional YAML Fields:**
- `color` - Visual identifier (blue, green, yellow, red)
- `model` - Which Claude model to use (haiku, sonnet, opus, inherit)
- `user-invocable` - Show in menus (default: true)
- `skills` - Available skills for subagents

**Content:**
- Markdown documentation following the frontmatter
- Detailed agent instructions
- Examples and best practices
- Context about expertise and approach

### 4. Command Definitions

**Location:** `.claude/commands/*.md`

**Format:** Markdown files (filename becomes command name)

**Example:**
```markdown
---
description: "Orchestrate complete product design workflow"
argument-hint: [feature_name, description]
model: sonnet
---

# Product Design Command

This command coordinates multiple agents to create a complete product design:
1. Requirements (product-manager)
2. Architecture (system-architect)
3. Implementation plan (project-manager)

Usage: /product-design feature-name "description"
```

**YAML Frontmatter Fields:**
- `description` - Command purpose
- `argument-hint` - Expected arguments
- `allowed-tools` - Restricted tool access
- `model` - Preferred model

**Content:**
- Instructions for command execution
- Workflow description
- Parameter usage
- Dynamic content with `!` prefix

## Directory Structure

```
code-agents/
├── .claude-plugin/              # Official marketplace metadata
│   ├── plugin.json              # Plugin manifest (REQUIRED)
│   └── marketplace.json         # Marketplace definition (REQUIRED for collections)
│
├── .claude/                     # Component definitions
│   ├── agents/                  # Agent definitions
│   │   ├── product-manager.md
│   │   ├── system-architect.md
│   │   ├── security-code-reviewer.md
│   │   └── ... (7 total)
│   └── commands/                # Command definitions
│       ├── product-design.md
│       └── issue-implementation.md
│
├── registry.json                # Enhanced custom registry (our addition)
├── install.sh                   # Installation script (our addition)
├── search.sh                    # Discovery tool (our addition)
├── info.sh                      # Info tool (our addition)
├── version.sh                   # Version management (our addition)
├── validate.sh                  # Validation tool (our addition)
├── index.html                   # Web browser (our addition)
│
├── README.md                    # Main documentation
├── CHANGELOG.md                 # Version history
├── ROADMAP.md                   # Future plans
├── USAGE_EXAMPLES.md            # Examples
└── MARKETPLACE.md               # This file
```

## Using This Marketplace

### Method 1: Native Claude Code Integration

**In Claude Code Settings:**
```json
{
  "plugins": [
    {
      "source": "https://github.com/skysec/code-agents"
    }
  ]
}
```

Claude Code will:
1. Read `.claude-plugin/plugin.json`
2. Load agents from `.claude/agents/`
3. Load commands from `.claude/commands/`
4. Make everything available natively

### Method 2: Git Submodule

```bash
cd your-project
git submodule add https://github.com/skysec/code-agents.git .claude-agents
ln -s .claude-agents/.claude/agents .claude/agents
ln -s .claude-agents/.claude/commands .claude/commands
```

### Method 3: Installation Script

```bash
git clone https://github.com/skysec/code-agents.git
cd your-project
/path/to/code-agents/install.sh --all
```

## Custom Extensions

This repository extends the official specification with:

### Enhanced Registry (`registry.json`)

Provides structured metadata for tooling:
```json
{
  "agents": [
    {
      "name": "security-code-reviewer",
      "version": "1.0.0",
      "category": "security",
      "description": "...",
      "file": ".claude/agents/security-code-reviewer.md",
      "tools": ["Glob", "Grep", ...],
      "color": "red",
      "use_cases": [
        "Security vulnerability review",
        "OWASP compliance check",
        ...
      ]
    }
  ],
  "categories": { /* category metadata */ }
}
```

**Benefits:**
- Easier discovery and search
- Rich metadata for tooling
- Category-based organization
- Version tracking
- Use case documentation

### CLI Tools

- `./search.sh` - Search agents by keyword
- `./info.sh` - Get detailed agent information
- `./install.sh` - Install agents to other projects
- `./version.sh` - Manage versions
- `./validate.sh` - Validate marketplace structure

### Web Interface

- `index.html` - Visual agent browser
- Category filtering
- Search functionality
- Responsive design
- Can be hosted on GitHub Pages

## Validation

Ensure compliance with official specification:

```bash
./validate.sh
```

This checks:
- ✅ `.claude-plugin/plugin.json` exists and is valid
- ✅ `.claude-plugin/marketplace.json` exists and is valid
- ✅ Plugin name is in kebab-case
- ✅ Required fields are present
- ✅ Agents have proper YAML frontmatter
- ✅ Commands are properly formatted
- ✅ Custom registry.json is valid
- ✅ All scripts are executable

## Version Management

Both formats support versioning:

**Plugin Version:**
```bash
# Update plugin.json version
./version.sh bump minor
```

**Marketplace Version:**
```bash
# Sync marketplace.json with plugin.json
# Bump individual agent versions
./version.sh bump-agent security-code-reviewer patch
```

**Registry Version:**
```bash
# Update registry.json
# Managed by version.sh
```

## Publishing

### As Official Claude Code Plugin

1. Ensure validation passes: `./validate.sh`
2. Tag release: `git tag -a v1.0.0 -m "Release v1.0.0"`
3. Push to GitHub: `git push origin main --tags`
4. Submit to official registry (if applicable)

### As Community Marketplace

1. Validate structure
2. Deploy to GitHub Pages (for web interface)
3. Share repository URL
4. List in community registries

### As Private Registry

1. Host on private Git server
2. Configure access controls
3. Share with team via Git URL
4. Use in projects via submodule or plugin reference

## Compliance Checklist

- [x] `.claude-plugin/plugin.json` exists
- [x] Plugin name is kebab-case
- [x] Version follows semver
- [x] Agents are in `.claude/agents/`
- [x] Commands are in `.claude/commands/`
- [x] All agents have YAML frontmatter
- [x] Agent frontmatter includes `name`, `description`, `tools`
- [x] `README.md` documents usage
- [x] License file exists
- [x] Repository is public (or properly shared)
- [x] `.claude-plugin/marketplace.json` for collections
- [x] Categories are defined
- [x] Validation script passes

## Reference Documentation

- [Claude Code Plugin Specification](https://code.claude.com/docs/en/plugins-reference)
- [Marketplace Creation Guide](https://code.claude.com/docs/en/plugin-marketplaces)
- [Agent Definition Format](https://code.claude.com/docs/en/sub-agents)
- [Command Format](https://code.claude.com/docs/en/slash-commands)
- [Official Plugins Repository](https://github.com/anthropics/claude-plugins-official)

## Questions & Support

- **Issues:** Report compatibility issues via GitHub Issues
- **Discussions:** Ask questions in GitHub Discussions
- **Contributions:** See CONTRIBUTING.md for guidelines
- **Validation:** Run `./validate.sh` before submitting

---

This marketplace is designed to work seamlessly with Claude Code's native plugin system while providing enhanced discovery and management features through custom tooling.
