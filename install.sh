#!/bin/bash
#
# Claude Code Marketplace Installer
#
# This script installs agents and commands from the Claude Code marketplace
#
# Usage:
#   ./install.sh [options]
#
# Options:
#   --all              Install all agents and commands
#   --agents-only      Install only agents
#   --commands-only    Install only commands
#   --target <path>    Target directory (default: current directory)
#   --help             Show this help message
#
# Examples:
#   ./install.sh --all                          # Install everything
#   ./install.sh --agents-only                  # Install only agents
#   ./install.sh --target /path/to/repo --all   # Install to specific directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
TARGET_DIR="."
INSTALL_AGENTS=true
INSTALL_COMMANDS=true

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Function to install all agents
install_agents() {
    print_info "Installing agents..."
    mkdir -p "$TARGET_DIR/.claude/agents"

    local count=0
    for agent_file in "$SCRIPT_DIR/.claude/agents"/*.md; do
        if [ -f "$agent_file" ]; then
            cp "$agent_file" "$TARGET_DIR/.claude/agents/"
            count=$((count + 1))
        fi
    done

    print_success "Installed $count agents"
}

# Function to install commands
install_commands() {
    print_info "Installing commands..."
    mkdir -p "$TARGET_DIR/.claude/commands"

    local count=0
    for command_file in "$SCRIPT_DIR/.claude/commands"/*.md; do
        if [ -f "$command_file" ]; then
            cp "$command_file" "$TARGET_DIR/.claude/commands/"
            count=$((count + 1))
        fi
    done

    print_success "Installed $count commands"
}

# Function to show help
show_help() {
    cat << EOF
Claude Code Marketplace Installer

This script installs agents and commands from the specialized-agents marketplace.

Usage:
  $0 [options]

Options:
  --all              Install all agents and commands (default)
  --agents-only      Install only agents
  --commands-only    Install only commands
  --target <path>    Target directory (default: current directory)
  --help             Show this help message

Examples:
  $0 --all                          # Install everything
  $0 --agents-only                  # Install only agents
  $0 --commands-only                # Install only commands
  $0 --target /path/to/repo --all   # Install to specific directory

What Gets Installed:

Agents (7 total):
  • product-manager              - Define product requirements and user stories
  • project-manager              - Break down projects into implementation tasks
  • system-architect             - Design system architecture and technology stack
  • senior-code-reviewer         - Comprehensive code reviews
  • security-code-reviewer       - Security vulnerability analysis
  • semgrep-specialist           - Create and enhance Semgrep rules
  • terraform-infrastructure-specialist - Terraform infrastructure code

Commands (2 total):
  • product-design               - Orchestrate complete product design workflow
  • issue-implementation         - Fetch GitHub issue and delegate to specialist

After Installation:
  Agents will be available in: $TARGET_DIR/.claude/agents/
  Commands will be available in: $TARGET_DIR/.claude/commands/

Alternative Installation Methods:
  1. Git Submodule: git submodule add <repo-url> .claude-marketplace
  2. Claude Code Settings: Add this repo URL to your plugin configuration

EOF
}

# Main script
main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                exit 0
                ;;
            --all|-a)
                INSTALL_AGENTS=true
                INSTALL_COMMANDS=true
                shift
                ;;
            --agents-only)
                INSTALL_AGENTS=true
                INSTALL_COMMANDS=false
                shift
                ;;
            --commands-only)
                INSTALL_AGENTS=false
                INSTALL_COMMANDS=true
                shift
                ;;
            --target|-t)
                TARGET_DIR="$2"
                shift 2
                ;;
            *)
                print_error "Unknown option: $1"
                echo ""
                show_help
                exit 1
                ;;
        esac
    done

    # Print header
    echo -e "\n${BLUE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Claude Code Marketplace Installer        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}\n"

    # Validate target directory
    if [ ! -d "$TARGET_DIR" ]; then
        print_error "Target directory does not exist: $TARGET_DIR"
        exit 1
    fi

    print_info "Target directory: $TARGET_DIR"

    # Install components
    if [ "$INSTALL_AGENTS" = true ]; then
        install_agents
    fi

    if [ "$INSTALL_COMMANDS" = true ]; then
        install_commands
    fi

    # Create context directory
    mkdir -p "$TARGET_DIR/.claude/context"

    # Print summary
    echo ""
    print_success "Installation complete!"
    echo ""
    if [ "$INSTALL_AGENTS" = true ]; then
        print_info "Agents installed in: $TARGET_DIR/.claude/agents/"
    fi
    if [ "$INSTALL_COMMANDS" = true ]; then
        print_info "Commands installed in: $TARGET_DIR/.claude/commands/"
    fi
    echo ""
    print_info "You can now use these agents and commands in Claude Code!"
    echo ""
}

# Run main function
main "$@"
