# Usage Examples & Integration Guide

This guide provides practical examples of using the Claude Code Agent Registry in various scenarios.

## Table of Contents

1. [Installation Examples](#installation-examples)
2. [Single Agent Usage](#single-agent-usage)
3. [Multi-Agent Workflows](#multi-agent-workflows)
4. [Orchestration Commands](#orchestration-commands)
5. [Team Integration](#team-integration)
6. [CI/CD Integration](#cicd-integration)
7. [Advanced Scenarios](#advanced-scenarios)

---

## Installation Examples

### Example 1: New Project Setup

You're starting a new web application and want all planning and security agents.

```bash
# Clone the registry
git clone https://github.com/skysec/code-agents.git ~/code-agents

# Navigate to your new project
cd ~/my-new-app

# Install planning and security agents
~/code-agents/install.sh --category planning
~/code-agents/install.sh --category security

# Also install orchestration commands
~/code-agents/install.sh --commands
```

**Result:** You now have:
- `product-manager` for requirements
- `project-manager` for task planning
- `security-code-reviewer` for security audits
- `semgrep-specialist` for security rules
- `/product-design` command for full workflow

### Example 2: Existing Project Enhancement

You have an existing project and want to add code review capabilities.

```bash
cd ~/existing-project

# Install only review agents
~/code-agents/install.sh senior-code-reviewer security-code-reviewer
```

### Example 3: Team-Wide Deployment (Submodule)

Your team wants to share agents across all repositories.

```bash
# In each team repository
git submodule add https://github.com/skysec/code-agents.git .claude-registry

# Create symlinks
mkdir -p .claude
ln -s ../.claude-registry/.claude/agents .claude/agents
ln -s ../.claude-registry/.claude/commands .claude/commands

# Commit
git add .gitmodules .claude-registry .claude
git commit -m "Add shared agent registry"
git push
```

**Team members can now:**
```bash
# Clone with submodules
git clone --recursive <repo-url>

# Or init submodules after clone
git submodule init
git submodule update
```

---

## Single Agent Usage

### Example 1: Security Review Before Deployment

**Scenario:** You've implemented a new authentication system and need security review.

```
User: I've implemented JWT-based authentication in auth.py. Can you review it for security issues?

Claude: I'll use the security-code-reviewer agent to analyze your authentication implementation.

[Agent conducts comprehensive security review focusing on:]
- Token generation and validation
- Secret storage
- Expiration handling
- Input validation
- Session management
```

**Expected Output:**
- List of security vulnerabilities found
- OWASP category classification
- Remediation recommendations
- Code examples for fixes

### Example 2: Architecture Design

**Scenario:** You need to design a microservices architecture for a new feature.

```
User: We need to add real-time notifications to our app. Can you design the architecture?

Claude: I'll use the system-architect agent to create a comprehensive design.

[Agent produces:]
- System architecture diagram
- Technology recommendations
- API specifications
- Data flow design
- Scalability considerations
```

**Deliverable:** `docs/architecture.md` with complete technical design.

### Example 3: Requirements Definition

**Scenario:** Product wants a new feature but requirements are unclear.

```
User: We need a user dashboard. Can you help define requirements?

Claude: I'll use the product-manager agent to create comprehensive requirements.

[Agent generates:]
- Functional requirements
- User stories
- Acceptance criteria
- Non-functional requirements (performance, security)
- Success metrics
```

**Deliverable:** `docs/requirements.md` with structured specifications.

---

## Multi-Agent Workflows

### Example 1: Feature Development Pipeline

**Scenario:** Complete feature development from concept to implementation plan.

**Step 1: Requirements** (product-manager)
```
User: Use product-manager to define requirements for user profile customization.

Output: docs/requirements.md
- 15 user stories
- Functional requirements
- UI/UX requirements
- Performance requirements
```

**Step 2: Architecture** (system-architect)
```
User: Now use system-architect to design the architecture based on requirements.

Output: docs/architecture.md
- Database schema
- API endpoints
- Frontend components
- State management approach
```

**Step 3: Planning** (project-manager)
```
User: Use project-manager to create implementation plan from the architecture.

Output: docs/tasks.md
- 45 specific tasks
- Dependency graph
- Complexity estimates
- Implementation sequence
```

**Step 4: Implementation** (developer)
```
User: [Implements based on plan]
```

**Step 5: Review** (senior-code-reviewer)
```
User: Review the implementation in src/profile/.

Output: Comprehensive review covering:
- Code quality
- Design patterns
- Test coverage
- Documentation
```

**Step 6: Security** (security-code-reviewer)
```
User: Security review of profile feature.

Output: Security analysis:
- No critical vulnerabilities
- 2 minor recommendations
- OWASP compliance confirmed
```

### Example 2: Infrastructure Project

**Scenario:** Deploy new Kubernetes cluster with proper governance.

**Step 1: Design** (system-architect)
```
User: Design a production Kubernetes architecture for our microservices.

Output: Complete k8s architecture with:
- Cluster topology
- Networking design
- Security policies
- Monitoring strategy
```

**Step 2: IaC Implementation** (terraform-infrastructure-specialist)
```
User: Create Terraform modules for the k8s design.

Output: Reusable Terraform modules:
- VPC module
- EKS cluster module
- Node groups module
- Add-ons module
```

**Step 3: Security Rules** (semgrep-specialist)
```
User: Create Semgrep rules to enforce Terraform best practices.

Output: Custom Semgrep rules:
- Version pinning
- Required tags
- Security group restrictions
- Sensitive data checks
```

**Step 4: Review** (terraform-infrastructure-specialist)
```
User: Review all Terraform code before deployment.

Output: Infrastructure review:
- Module design validation
- Best practices compliance
- Cost optimization suggestions
```

---

## Orchestration Commands

### Example 1: Product Design Workflow

**Command:** `/product-design user-notifications "Real-time notification system with email, SMS, and push notifications"`

**Workflow:**
```
1. product-manager
   ├─ Analyzes requirement
   ├─ Creates user stories
   ├─ Defines acceptance criteria
   └─ Outputs: docs/requirements.md

2. system-architect
   ├─ Reads requirements.md
   ├─ Designs notification architecture
   ├─ Selects technology stack
   └─ Outputs: docs/architecture.md

3. project-manager
   ├─ Reads architecture.md
   ├─ Breaks down into tasks
   ├─ Estimates complexity
   └─ Outputs: docs/tasks.md
```

**Time Saved:** ~2-3 hours of manual planning work

**Usage in Practice:**
```
# In Claude Code
/product-design payment-processing "Stripe integration with recurring subscriptions"

# Generates:
# - docs/requirements.md (12 user stories)
# - docs/architecture.md (API design, data models)
# - docs/tasks.md (38 implementation tasks)
```

### Example 2: GitHub Issue Implementation

**Command:** `/issue-implementation anthropics claude-code 456`

**Scenario:** GitHub issue #456 is about adding Terraform support.

**Workflow:**
```
1. Fetch issue from GitHub API
   ├─ Title: "Add Terraform provider support"
   ├─ Labels: infrastructure, enhancement
   └─ Body: [detailed requirements]

2. Analyze issue type
   └─ Infrastructure-related → Select terraform-infrastructure-specialist

3. Create context
   └─ .claude/context/456_task.md with issue details

4. Delegate to agent
   └─ terraform-infrastructure-specialist implements based on context
```

**Agent Selection Logic:**
- Infrastructure keywords → `terraform-infrastructure-specialist`
- Security keywords → `security-code-reviewer`
- "Review" in title → `senior-code-reviewer`
- "Design" in title → `system-architect`
- "Requirements" → `product-manager`
- "Plan" → `project-manager`

---

## Team Integration

### Example 1: Development Team Workflow

**Team Structure:**
- 5 developers
- 1 tech lead
- 1 product manager

**Setup:**
```bash
# Tech lead sets up registry in team repo
git submodule add https://github.com/skysec/code-agents.git .claude-registry
ln -s .claude-registry/.claude/agents .claude/agents
ln -s .claude-registry/.claude/commands .claude/commands
git commit -am "Add agent registry for team"
```

**Usage Pattern:**

**Product Manager:**
```
# Define new features
/product-design shopping-cart "Multi-vendor shopping cart with split payments"

# Review: docs/requirements.md
# Share with team
```

**Tech Lead:**
```
# Design architecture
Uses system-architect for high-level design

# Review pull requests
Uses senior-code-reviewer for code reviews
```

**Developers:**
```
# Implement based on docs/tasks.md

# Get security reviews
Uses security-code-reviewer before merging

# Create infrastructure
Uses terraform-infrastructure-specialist for deployments
```

### Example 2: Open Source Project

**Scenario:** Open source project wants contributors to use standardized agents.

**Setup in Repository:**
```bash
# Add to .github/CONTRIBUTING.md
## Using Claude Code Agents

This project uses Claude Code agents to maintain quality standards.

### Setup
```bash
git submodule init
git submodule update
```

### Before Submitting PRs
1. Run security review: use `security-code-reviewer`
2. Run code review: use `senior-code-reviewer`
3. Update tests as suggested
```

**Benefit:** Consistent code quality across all contributors.

---

## CI/CD Integration

### Example 1: Pre-commit Security Scan

**Scenario:** Automatically scan code for security issues before commit.

**Setup:** `.git/hooks/pre-commit`
```bash
#!/bin/bash
# Use Semgrep rules created by semgrep-specialist

echo "Running security scan..."
semgrep --config .semgrep/rules scan .

if [ $? -ne 0 ]; then
    echo "Security issues found. Please fix before committing."
    exit 1
fi
```

**Workflow:**
1. Developer writes code
2. Pre-commit hook runs Semgrep
3. Issues blocked if vulnerabilities found
4. Developer uses `security-code-reviewer` to fix
5. Commit proceeds

### Example 2: PR Review Automation

**Scenario:** Automatically generate review comments on PRs.

**GitHub Actions:** `.github/workflows/agent-review.yml`
```yaml
name: Agent Code Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive

      - name: Run Senior Code Reviewer
        uses: anthropics/claude-code-action@v1
        with:
          agent: senior-code-reviewer
          path: ${{ github.event.pull_request.changed_files }}

      - name: Run Security Reviewer
        uses: anthropics/claude-code-action@v1
        with:
          agent: security-code-reviewer
          path: ${{ github.event.pull_request.changed_files }}
```

**Result:** Automated review comments on every PR.

### Example 3: Terraform Plan Review

**Scenario:** Review Terraform changes before apply.

**GitLab CI:** `.gitlab-ci.yml`
```yaml
terraform-review:
  stage: review
  script:
    - git submodule update --init
    - claude-code --agent terraform-infrastructure-specialist --task "Review Terraform plan"
  only:
    - merge_requests
  when: manual
```

---

## Advanced Scenarios

### Example 1: Custom Agent Workflow

**Scenario:** You want a custom workflow that checks security, then reviews, then deploys.

**Create:** `.claude/commands/secure-deploy.md`
```yaml
---
name: secure-deploy
description: Security review, code review, then deployment checklist
agents_used: [security-code-reviewer, senior-code-reviewer]
---

# Secure Deployment Workflow

1. Run security-code-reviewer on changed files
2. If security review passes, run senior-code-reviewer
3. If code review passes, generate deployment checklist
4. Verify checklist items
5. Deploy

[Detailed instructions for each step]
```

**Usage:**
```
/secure-deploy src/api/
```

### Example 2: Multi-Repository Agent Sharing

**Scenario:** Company with 50+ repositories wants shared agents.

**Central Registry Repository:**
```
company-agents/
├── .claude/
│   ├── agents/
│   │   ├── [7 standard agents]
│   │   ├── company-specific-reviewer.md
│   │   └── compliance-checker.md
│   └── commands/
│       └── company-workflow.md
├── registry.json
└── install.sh
```

**Each Product Repository:**
```bash
# Add as submodule
git submodule add git@github.com:company/company-agents.git .agents

# Symlink
ln -s .agents/.claude .claude

# All repos now use same agents
# Updates propagate via git submodule update
```

### Example 3: Agent Development & Testing

**Scenario:** You're developing a new custom agent.

**Development Process:**
```bash
# 1. Create agent
cat > .claude/agents/api-documentation-specialist.md << 'EOF'
---
name: api-documentation-specialist
description: Generates comprehensive API documentation
tools: [Grep, Read, Write]
color: blue
---

You are an API documentation specialist...
EOF

# 2. Test the agent
# Use in Claude Code to verify behavior

# 3. Update registry
./version.sh bump-agent api-documentation-specialist minor

# 4. Update registry.json
# Add agent metadata

# 5. Document
# Update README.md with agent description

# 6. Commit and share
git add .claude/agents/api-documentation-specialist.md registry.json
git commit -m "Add API documentation specialist agent"
git push
```

### Example 4: Dynamic Agent Selection

**Scenario:** Automatically select best agent based on file type.

**Create:** `.claude/commands/smart-review.md`
```yaml
---
name: smart-review
description: Automatically select appropriate reviewer based on file type
---

# Smart Review

Analyze file types and select agent:
- *.tf → terraform-infrastructure-specialist
- *.py, *.js (with auth/crypto) → security-code-reviewer
- *.yaml (semgrep rules) → semgrep-specialist
- Other code → senior-code-reviewer
```

---

## Best Practices

### When to Use Which Agent

| Situation | Agent | Why |
|-----------|-------|-----|
| Starting new feature | product-manager | Define requirements first |
| Unclear architecture | system-architect | Need technical design |
| Breaking down work | project-manager | Create actionable tasks |
| Before PR merge | senior-code-reviewer | Ensure code quality |
| Security-sensitive code | security-code-reviewer | Find vulnerabilities |
| Infrastructure changes | terraform-infrastructure-specialist | IaC best practices |
| Custom security rules | semgrep-specialist | Static analysis |

### Workflow Patterns

**Pattern 1: Waterfall**
```
Requirements → Architecture → Planning → Implementation → Review
(product-manager → system-architect → project-manager → dev → senior-code-reviewer)
```

**Pattern 2: Iterative**
```
Quick design → Implement → Review → Refine design → Repeat
(system-architect → dev → senior-code-reviewer → system-architect → ...)
```

**Pattern 3: Security-First**
```
Requirements → Threat Model → Design → Security Review → Implement → Security Review
(product-manager → security-code-reviewer → system-architect → security-code-reviewer → dev → security-code-reviewer)
```

### Team Collaboration

**Recommended Structure:**
```
.claude/
├── agents/           # Shared from registry
├── commands/         # Team-specific + registry
└── context/          # Project-specific context
    ├── architecture.md
    ├── standards.md
    └── conventions.md
```

**Custom Context:** Add project-specific guidelines that agents should follow.

---

## Troubleshooting Common Scenarios

### Scenario: Agent Doesn't Have Needed Tool

**Problem:** Agent can't access a tool you need.

**Solution:** Create custom agent variant:
```bash
cp .claude/agents/senior-code-reviewer.md .claude/agents/my-code-reviewer.md
# Edit tools list to add needed tools
```

### Scenario: Conflicting Agent Recommendations

**Problem:** Two agents give different suggestions.

**Solution:** Use higher-level orchestration:
```
1. Get both recommendations
2. Use system-architect to reconcile
3. Document decision in .claude/context/decisions.md
```

### Scenario: Agent Output Too Generic

**Problem:** Agent suggestions don't fit your project.

**Solution:** Add project context:
```bash
# Create .claude/context/project-context.md
- Tech stack: React, Node.js, PostgreSQL
- Code style: Airbnb ESLint
- Test framework: Jest
- Deployment: AWS ECS

# Agents will reference this context
```

---

## Next Steps

- Explore the [README](README.md) for installation details
- Check [CHANGELOG](CHANGELOG.md) for version history
- Review agent definitions in `.claude/agents/`
- Join discussions to share your use cases

**Happy agent-assisted development!** 🚀
