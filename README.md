# Claude Code Agent Registry

A curated collection of specialized AI agents for Claude Code, designed to enhance your software development workflow.

## 🎯 What is This?

This repository serves as a **registry** of reusable Claude Code agents that can be installed into any project. Think of it like npm for Claude Code agents - a centralized repository of specialized AI assistants that you can pull into your projects as needed.

## 📦 Available Agents

### Planning & Requirements
- **product-manager** - Define comprehensive product requirements, user stories, and acceptance criteria
- **project-manager** - Transform designs into detailed implementation plans with task breakdown and sequencing

### Design & Architecture
- **system-architect** - Create system architecture designs, technology recommendations, and API specifications

### Code Quality
- **senior-code-reviewer** - Conduct thorough code reviews focused on architecture, design patterns, and best practices

### Security
- **security-code-reviewer** - Review code for security vulnerabilities using OWASP framework
- **semgrep-specialist** - Create and enhance Semgrep rules for static code analysis

### Infrastructure
- **terraform-infrastructure-specialist** - Design, review, and optimize Terraform infrastructure code

## 🚀 Quick Start

### Option 1: Using the Install Script (Recommended)

```bash
# Clone the registry
git clone https://github.com/skysec/code-agents.git

# Navigate to your project
cd /path/to/your/project

# Install all agents
/path/to/code-agents/install.sh --all

# Or install specific agents
/path/to/code-agents/install.sh security-code-reviewer semgrep-specialist

# Or install by category
/path/to/code-agents/install.sh --category security --commands
```

### Option 2: Git Submodule (For Teams)

```bash
# In your project repository
cd /path/to/your/project

# Add as submodule
git submodule add https://github.com/skysec/code-agents.git .claude-registry

# Create symlinks
ln -s .claude-registry/.claude/agents .claude/agents
ln -s .claude-registry/.claude/commands .claude/commands

# Commit the submodule
git add .gitmodules .claude-registry .claude
git commit -m "Add Claude Code agent registry"
```

To update agents in the future:
```bash
git submodule update --remote .claude-registry
```

### Option 3: Direct Copy

```bash
# Copy agents directory
cp -r /path/to/code-agents/.claude/agents /path/to/your/project/.claude/

# Optionally copy commands
cp -r /path/to/code-agents/.claude/commands /path/to/your/project/.claude/
```

## 📋 Installation Script Usage

```bash
./install.sh [options] [agent-names...]

Options:
  --all              Install all agents
  --category <cat>   Install all agents from a category
  --list             List available agents
  --commands         Also install orchestration commands
  --target <path>    Target directory (default: current directory)
  --help             Show this help message

Categories:
  planning           Product and project management agents
  design             Architecture and design agents
  quality            Code review agents
  security           Security analysis agents
  infrastructure     Infrastructure as code agents
```

### Examples

```bash
# List all available agents
./install.sh --list

# Install all agents to current directory
./install.sh --all

# Install specific agent
./install.sh security-code-reviewer

# Install all security agents
./install.sh --category security

# Install everything including orchestration commands
./install.sh --all --commands

# Install to a specific directory
./install.sh --target /path/to/project --all
```

## 🎭 Orchestration Commands

In addition to individual agents, this registry provides **orchestration commands** that coordinate multiple agents to complete complex workflows:

### `/product-design`

Orchestrates a complete product design workflow from requirements to implementation plan.

**Usage:**
```
/product-design <feature_name> "<description>"
```

**Workflow:**
1. `product-manager` → Generates `docs/requirements.md`
2. `system-architect` → Generates `docs/architecture.md`
3. `project-manager` → Generates `docs/tasks.md`

**Example:**
```
/product-design user-authentication "Implement secure user authentication with OAuth2"
```

### `/issue-implementation`

Fetches GitHub issue information and delegates to the most appropriate specialist agent.

**Usage:**
```
/issue-implementation <owner> <repo> <issue-id>
```

**Agent Selection:**
- Infrastructure/DevOps issues → `terraform-infrastructure-specialist`
- Security issues → `security-code-reviewer`
- Code review requests → `senior-code-reviewer`
- Feature specifications → `product-manager`
- System design → `system-architect`
- Project planning → `project-manager`

**Example:**
```
/issue-implementation anthropics claude-code 123
```

## 🔧 Agent Details

### Product Manager
**File:** `.claude/agents/product-manager.md`

Specializes in defining comprehensive product requirements.

**Capabilities:**
- Functional and non-functional requirements
- User stories and acceptance criteria
- Success metrics and KPIs
- Compliance and regulatory requirements

**Use When:**
- Starting a new feature
- Clarifying requirements
- Documenting product specifications

---

### Project Manager
**File:** `.claude/agents/project-manager.md`

Transforms architectural designs into actionable implementation plans.

**Capabilities:**
- Task breakdown and sequencing
- Complexity assessment
- Dependency mapping
- Risk identification

**Use When:**
- Planning implementation work
- Breaking down large features
- Estimating project scope

---

### System Architect
**File:** `.claude/agents/system-architect.md`

Creates comprehensive system architecture designs.

**Capabilities:**
- Technology stack recommendations
- API design and specifications
- Data modeling
- Scalability and performance planning
- Security architecture

**Use When:**
- Designing new systems
- Making technology decisions
- Planning major refactors
- Architectural reviews

---

### Senior Code Reviewer
**File:** `.claude/agents/senior-code-reviewer.md`

Conducts thorough code reviews with senior-level expertise.

**Capabilities:**
- Architecture and design pattern analysis
- Code quality assessment
- Performance optimization
- Test coverage review
- Dependency analysis

**Use When:**
- Reviewing pull requests
- Code audits
- Refactoring validation
- Best practices enforcement

---

### Security Code Reviewer
**File:** `.claude/agents/security-code-reviewer.md`

Specialized security vulnerability analysis using OWASP framework.

**Capabilities:**
- Input validation review
- Authentication/authorization checks
- Data protection analysis
- Injection vulnerability detection
- Security misconfiguration detection

**Use When:**
- Security audits
- Pre-deployment reviews
- Compliance checks
- Vulnerability assessments

---

### Semgrep Specialist
**File:** `.claude/agents/semgrep-specialist.md`

Creates and enhances Semgrep rules for static code analysis.

**Capabilities:**
- Custom rule creation
- Rule optimization
- Test case development
- Policy configuration

**Use When:**
- Setting up code scanning
- Creating custom security rules
- Validating code patterns
- Automating code quality checks

---

### Terraform Infrastructure Specialist
**File:** `.claude/agents/terraform-infrastructure-specialist.md`

Expert in Terraform infrastructure as code.

**Capabilities:**
- Reusable module creation
- Multi-environment configuration
- Provider version management
- State management
- CI/CD integration

**Use When:**
- Creating infrastructure
- Reviewing Terraform code
- Module design
- Infrastructure optimization

## 📚 Registry Structure

```
code-agents/
├── .claude/
│   ├── agents/              # Individual agent definitions
│   │   ├── product-manager.md
│   │   ├── project-manager.md
│   │   ├── system-architect.md
│   │   ├── senior-code-reviewer.md
│   │   ├── security-code-reviewer.md
│   │   ├── semgrep-specialist.md
│   │   └── terraform-infrastructure-specialist.md
│   ├── commands/            # Orchestration commands
│   │   ├── product-design.md
│   │   └── issue-implementation.md
│   └── context/             # Task context files (generated)
├── docs/                    # Documentation
│   └── DEVELOPMENT.md
├── registry.json            # Agent registry manifest
├── install.sh               # Installation script
└── README.md                # This file
```

## 🔄 Keeping Agents Updated

### Using Git Submodule

```bash
# Update to latest agents
git submodule update --remote .claude-registry

# Commit the update
git add .claude-registry
git commit -m "Update agent registry"
```

### Using Install Script

```bash
# Re-run installation to get latest versions
/path/to/code-agents/install.sh --all
```

### Manual Update

```bash
# Pull latest changes
cd /path/to/code-agents
git pull

# Re-copy to your project
cp -r .claude/agents /path/to/your/project/.claude/
```

## 🎨 Customizing Agents

You can customize agents for your project:

1. Install the base agent from the registry
2. Edit the agent file in your project's `.claude/agents/` directory
3. Your customizations won't be overwritten unless you re-install

**Note:** If you make improvements, consider contributing them back to the registry!

## 🤝 Contributing New Agents

We welcome contributions! To add a new agent:

1. Create a new `.md` file in `.claude/agents/`
2. Follow the existing agent format:
   ```yaml
   ---
   name: agent-name
   description: When to use this agent...
   tools: [List, Of, Tools]
   color: blue|green|yellow|red
   ---

   [Agent instructions in Markdown]
   ```
3. Update `registry.json` with agent metadata
4. Submit a pull request

## 📖 Agent Format Specification

Each agent is defined as a Markdown file with YAML frontmatter:

```yaml
---
name: agent-name                    # Unique identifier
description: |                       # When to use this agent (shown in UI)
  Use this agent when...
  Examples: <example>...</example>
tools: [Tool1, Tool2, ...]          # Available tools
color: blue|green|yellow|red        # Visual identifier
model: inherit                       # Optional: model override
---

# Agent Instructions

Detailed instructions for the agent's behavior, expertise,
and best practices...
```

## 🔐 Security Considerations

- **Review agents before installation** - Agents have access to powerful tools
- **Audit custom agents** - If you modify agents, ensure they follow security best practices
- **Keep agents updated** - Security agents evolve to detect new vulnerabilities
- **Use appropriate agents** - Match the agent to your security requirements

## 📝 Version Management

The registry uses semantic versioning:

- **registry.json** contains version information for each agent
- **Breaking changes** increment major version
- **New features** increment minor version
- **Bug fixes** increment patch version

Check `registry.json` for current versions.

## 🐛 Troubleshooting

### Agents not appearing in Claude Code

1. Ensure agents are in `.claude/agents/` directory
2. Check file permissions (should be readable)
3. Verify YAML frontmatter is valid
4. Restart Claude Code session

### Installation script fails

1. Check you have execute permissions: `chmod +x install.sh`
2. Verify target directory exists
3. Ensure you have write permissions to target directory

### Submodule issues

```bash
# Initialize submodules if not done
git submodule init
git submodule update

# Reset submodule
git submodule deinit -f .claude-registry
git submodule update --init
```

## 📄 License

See LICENSE file for details.

## 🙏 Acknowledgments

Built for the Claude Code community to accelerate software development workflows.

## 📮 Support

- **Issues:** Report bugs or request features via GitHub Issues
- **Discussions:** Share use cases and best practices in GitHub Discussions
- **Documentation:** Contribute improvements to agent documentation

---

**Happy Coding with Claude!** 🚀
