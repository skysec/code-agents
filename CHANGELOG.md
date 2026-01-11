# Changelog

All notable changes to the Claude Code Agent Registry will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-11

### Added
- Initial release of Claude Code Agent Registry
- Product Manager agent for requirements definition
- Project Manager agent for implementation planning
- System Architect agent for architecture design
- Senior Code Reviewer agent for code quality review
- Security Code Reviewer agent for security analysis
- Semgrep Specialist agent for static analysis rules
- Terraform Infrastructure Specialist agent for IaC
- Product Design orchestration command
- Issue Implementation orchestration command
- Registry manifest (registry.json)
- Installation script (install.sh)
- Comprehensive documentation (README.md)

### Infrastructure
- Set up agent registry structure
- Created installation mechanisms
- Implemented version management
- Added category-based agent organization

## [Unreleased]

### Planned
- Web-based agent browser
- Agent dependency resolution
- Remote agent installation from GitHub
- Agent testing framework
- Community contribution guidelines
- Agent marketplace integration

---

## Version Guidelines

### Version Format
- **MAJOR.MINOR.PATCH** (e.g., 1.0.0)

### Version Increments
- **MAJOR**: Breaking changes to agent interfaces or behavior
- **MINOR**: New agents, new features, backward-compatible changes
- **PATCH**: Bug fixes, documentation updates, minor improvements

### Agent Versioning
Each agent maintains its own version in registry.json:
- Changes to agent behavior → increment agent version
- Registry updates don't always require agent version changes
- Track agent changes in this CHANGELOG

### Release Process
1. Update agent versions in registry.json
2. Document changes in CHANGELOG.md
3. Create git tag: `git tag -a v1.0.0 -m "Release v1.0.0"`
4. Push tag: `git push origin v1.0.0`
