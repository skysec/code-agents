# Changelog

All notable changes to the Claude Code Agent Marketplace will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-11

### Added
- Initial release of Claude Code Agent Marketplace
- Product Manager agent for requirements definition
- Project Manager agent for implementation planning
- System Architect agent for architecture design
- Senior Code Reviewer agent for code quality review
- Security Code Reviewer agent for security analysis
- Semgrep Specialist agent for static analysis rules
- Terraform Infrastructure Specialist agent for IaC
- Product Design orchestration command
- Issue Implementation orchestration command
- Official Claude Code plugin manifest (.claude-plugin/plugin.json)
- Official marketplace definition (.claude-plugin/marketplace.json)
- Installation script (install.sh)
- Validation script (validate.sh)
- Web interface for browsing agents (index.html)
- Comprehensive documentation (README.md, MARKETPLACE.md)

### Infrastructure
- Implemented official Claude Code marketplace specification
- Created plugin manifest conforming to kebab-case naming
- Defined marketplace structure with categories
- Set up agent directory (.claude/agents/)
- Set up commands directory (.claude/commands/)
- Added YAML frontmatter to all agent definitions
- Implemented validation tooling

## [Unreleased]

### Planned
- GitHub Pages deployment for web interface
- Enhanced search and discovery features
- Agent dependency resolution
- Remote installation capabilities
- Agent testing framework
- Community contribution guidelines

---

## Version Guidelines

### Version Format
- **MAJOR.MINOR.PATCH** (e.g., 1.0.0)

### Version Increments
- **MAJOR**: Breaking changes to agent interfaces or marketplace structure
- **MINOR**: New agents, new features, backward-compatible changes
- **PATCH**: Bug fixes, documentation updates, minor improvements

### Marketplace Versioning
Agent versions are managed in .claude-plugin/marketplace.json:
- Changes to agent behavior → document in changelog
- Marketplace updates require version bump in plugin.json
- Track all changes in this CHANGELOG

### Release Process
1. Update version in .claude-plugin/plugin.json
2. Update .claude-plugin/marketplace.json if needed
3. Document changes in CHANGELOG.md
4. Create git tag: `git tag -a v1.0.0 -m "Release v1.0.0"`
5. Push tag: `git push origin v1.0.0`
6. Validate: `./validate.sh`
