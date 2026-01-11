# Roadmap: From Registry to Marketplace

This document outlines the evolution path from the current Agent Registry to a full-fledged Claude Code Agent Marketplace.

## Current State: Agent Registry (v1.0)

**What we have:**
- ✅ Structured agent catalog (registry.json)
- ✅ Installation mechanism (install.sh)
- ✅ Version management (version.sh)
- ✅ Documentation and examples
- ✅ Git-based distribution

**Functionality:**
- Manual curation
- Git-based installation
- Version tracking
- Category organization

---

## Marketplace Features Roadmap

### Phase 1: Enhanced Registry (v1.x)

#### 1.1 Remote Installation
**Goal:** Install agents directly from GitHub without cloning

```bash
# Install from remote registry
curl -sSL https://raw.githubusercontent.com/skysec/code-agents/main/install.sh | bash -s -- --all

# Or with npx-style execution
npx @claude/agent-installer security-code-reviewer
```

**Requirements:**
- [ ] Modify install.sh to support remote URLs
- [ ] Add checksum verification
- [ ] Cache downloaded agents locally

#### 1.2 Agent Search & Discovery
**Goal:** CLI-based search functionality

```bash
# Search for agents
./search.sh security
# Results: security-code-reviewer, semgrep-specialist

# Get agent details
./info.sh security-code-reviewer
```

**Requirements:**
- [ ] Create search.sh script
- [ ] Create info.sh script
- [ ] Add tags/keywords to registry.json
- [ ] Implement fuzzy search

#### 1.3 Dependency Management
**Goal:** Agents can depend on other agents or tools

```json
{
  "name": "full-stack-reviewer",
  "dependencies": {
    "agents": ["security-code-reviewer", "senior-code-reviewer"],
    "tools": ["semgrep>=1.0.0", "eslint>=8.0.0"]
  }
}
```

**Requirements:**
- [ ] Add dependency fields to registry.json
- [ ] Implement dependency resolution in install.sh
- [ ] Check for circular dependencies
- [ ] Install dependencies automatically

#### 1.4 Statistics & Metrics
**Goal:** Track agent usage and popularity

```json
{
  "name": "security-code-reviewer",
  "stats": {
    "downloads": 1250,
    "stars": 45,
    "last_updated": "2026-01-11"
  }
}
```

**Requirements:**
- [ ] Add telemetry to install.sh (opt-in)
- [ ] Create stats.json for tracking
- [ ] Display popular agents
- [ ] Show trending agents

---

### Phase 2: Web Marketplace (v2.0)

#### 2.1 Web Frontend
**Goal:** Browse agents via web interface

**Features:**
- Agent catalog with search/filter
- Detailed agent pages
- Category browsing
- Installation instructions
- Live preview/demo

**Tech Stack:**
- Static site generator (Hugo, Jekyll, Next.js)
- Hosted on GitHub Pages
- API: serve registry.json via CDN

**Mockup:**
```
┌─────────────────────────────────────────┐
│ 🔍 Search agents...        [Categories▾]│
├─────────────────────────────────────────┤
│ 🔒 Security                             │
│ ├─ security-code-reviewer    ⭐ 45      │
│ │  OWASP-based security analysis        │
│ │  [View] [Install]                     │
│ └─ semgrep-specialist        ⭐ 32      │
│    Create Semgrep rules                 │
│    [View] [Install]                     │
├─────────────────────────────────────────┤
│ 📋 Planning                             │
│ ├─ product-manager           ⭐ 38      │
│ └─ project-manager           ⭐ 29      │
└─────────────────────────────────────────┘
```

#### 2.2 Agent Publishing Workflow
**Goal:** Community members can submit agents

**Workflow:**
```
1. Developer creates agent locally
2. Tests agent in their project
3. Runs validation: ./validate-agent.sh my-agent.md
4. Submits PR to registry repo
5. Automated checks run (CI/CD)
6. Maintainer reviews and approves
7. Agent published to marketplace
8. Version auto-incremented
```

**Requirements:**
- [ ] Agent validation script
- [ ] PR template for new agents
- [ ] CI/CD checks (syntax, required fields)
- [ ] Automated testing framework
- [ ] Maintainer review guidelines

#### 2.3 CLI Marketplace Client
**Goal:** npm-like CLI for marketplace interaction

```bash
# Install CLI
npm install -g @claude/agent-marketplace

# Search marketplace
claude-agent search security

# Install from marketplace
claude-agent install security-code-reviewer

# Update all installed agents
claude-agent update

# List installed agents
claude-agent list

# Publish your own agent
claude-agent publish ./my-agent.md
```

**Requirements:**
- [ ] Build Node.js CLI tool
- [ ] API client for registry
- [ ] Local agent management
- [ ] Configuration file (~/.claude-agents)

---

### Phase 3: Advanced Marketplace (v3.0)

#### 3.1 Community Features

**Ratings & Reviews:**
```json
{
  "name": "security-code-reviewer",
  "rating": 4.8,
  "reviews": [
    {
      "user": "dev123",
      "rating": 5,
      "comment": "Caught SQL injection I missed!",
      "date": "2026-01-10"
    }
  ]
}
```

**Verified Agents:**
- Official agents (by Anthropic)
- Community-verified agents
- Security-audited badge

**Agent Authors:**
- Author profiles
- Published agent portfolios
- Reputation scores

#### 3.2 Agent Collections
**Goal:** Curated bundles of related agents

```yaml
collections:
  - name: "Full Stack Development"
    agents:
      - senior-code-reviewer
      - security-code-reviewer
      - system-architect
    install: claude-agent install-collection full-stack

  - name: "DevOps & Infrastructure"
    agents:
      - terraform-infrastructure-specialist
      - system-architect
      - security-code-reviewer
```

#### 3.3 Private Registries
**Goal:** Organizations can host private agent registries

```bash
# Configure private registry
claude-agent registry add company https://agents.company.com

# Install from private registry
claude-agent install --registry company proprietary-agent

# Publish to private registry
claude-agent publish --registry company ./internal-agent.md
```

**Architecture:**
- Self-hosted registry server
- Authentication & authorization
- Mirror public marketplace
- Private + public agent mixing

#### 3.4 Agent Analytics
**Goal:** Track agent performance and usage patterns

**Metrics:**
- Execution time
- Success rate
- Error patterns
- Common use cases
- Performance benchmarks

**Dashboard:**
- Agent health monitoring
- Usage trends
- Performance comparisons
- Community insights

---

### Phase 4: AI-Powered Features (v4.0)

#### 4.1 Agent Recommendations
**Goal:** AI suggests best agents for user's task

```
User: "I need to review Python code for security issues"

Marketplace AI:
Based on your request, I recommend:
1. security-code-reviewer (95% match)
   - Python security analysis
   - OWASP coverage
2. semgrep-specialist (70% match)
   - Custom Python rules
3. senior-code-reviewer (60% match)
   - General code quality
```

#### 4.2 Agent Composition
**Goal:** Automatically create workflows from multiple agents

```
User: "I want to build a new REST API"

Marketplace:
Created workflow:
1. product-manager → Define requirements
2. system-architect → Design API
3. project-manager → Create tasks
4. [Development]
5. senior-code-reviewer → Review code
6. security-code-reviewer → Security check

Install this workflow? [Y/n]
```

#### 4.3 Agent Testing & Validation
**Goal:** Automated agent quality assessment

```yaml
agent-tests:
  - name: "Security reviewer catches SQL injection"
    input: "vulnerable-code.py"
    expected:
      - type: "security-issue"
      - category: "SQL Injection"
      - severity: "high"

  - name: "Performance test"
    input: "large-codebase/"
    max_time: 30s
    max_memory: 2GB
```

#### 4.4 Agent Marketplace API
**Goal:** Programmatic access to marketplace

```javascript
// RESTful API
GET /api/v1/agents
GET /api/v1/agents/{name}
POST /api/v1/agents (publish)
GET /api/v1/agents/search?q=security
GET /api/v1/agents/trending
GET /api/v1/collections

// GraphQL API
query {
  agent(name: "security-code-reviewer") {
    version
    rating
    downloads
    dependencies
    reviews(limit: 5) {
      rating
      comment
    }
  }
}
```

---

## Implementation Priorities

### Immediate (v1.1-1.4) - Next 3 months
1. ✅ **Remote installation** - Highest impact, easiest
2. ✅ **Search CLI** - Essential for discovery
3. ⚠️  **Basic statistics** - Track what's popular
4. ⚠️  **Dependencies** - Needed as ecosystem grows

### Short-term (v2.0) - 6 months
1. **Web frontend** - Critical for adoption
2. **Publishing workflow** - Enable community
3. **CLI client** - Better UX than scripts

### Medium-term (v3.0) - 12 months
1. **Community features** - Build ecosystem
2. **Collections** - Easier onboarding
3. **Private registries** - Enterprise adoption

### Long-term (v4.0) - 18+ months
1. **AI recommendations** - Differentiation
2. **Agent composition** - Advanced workflows
3. **Marketplace API** - Integrations

---

## Success Metrics

### Registry Metrics (Current)
- Number of agents: 7
- Installation methods: 3
- Documentation coverage: 100%

### Marketplace Metrics (Target)
- **v1.x**: 20+ agents, 100+ installs/month
- **v2.0**: 50+ agents, web traffic 1k+ views/month, 10+ contributors
- **v3.0**: 100+ agents, 10k+ downloads/month, private registries: 5+
- **v4.0**: 500+ agents, 100k+ downloads/month, API integrations: 20+

---

## Technical Architecture Evolution

### Current: Git-Based Registry
```
GitHub Repo → Clone/Submodule → Local Install
```

### v2.0: Hybrid
```
GitHub Repo → GitHub Pages → CDN → CLI/Web
     ↓
  registry.json (API)
```

### v3.0: Distributed
```
Public Registry ←→ Private Registries
      ↓                   ↓
   CDN/API            Local API
      ↓                   ↓
   CLI Client  ←→   CLI Client
```

### v4.0: Platform
```
┌─────────────────────────────────────┐
│         Marketplace Platform        │
├─────────────────────────────────────┤
│  Web UI  │  API  │  AI Engine      │
├─────────────────────────────────────┤
│  Registry │ Analytics │ Publishing  │
├─────────────────────────────────────┤
│  Public Agents │ Private Agents     │
└─────────────────────────────────────┘
         ↓              ↓
    CLI Client    IDE Integration
```

---

## Getting Started Contributing

Want to help build the marketplace? Here's how:

### For v1.x Features:
1. Pick an issue from Phase 1
2. Fork the repo
3. Implement the feature
4. Submit PR with tests
5. Update documentation

### For Web Frontend (v2.0):
1. Design mockups (Figma)
2. Choose tech stack
3. Build static site
4. Integrate with registry.json
5. Deploy to GitHub Pages

### For Community:
1. Create new agents
2. Write tutorials
3. Share use cases
4. Report issues
5. Suggest improvements

---

## Questions & Discussion

- What features matter most to you?
- What agents would you like to see?
- How would you use a marketplace?
- Enterprise requirements?

Open an issue to discuss!
