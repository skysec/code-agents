#!/bin/bash
#
# Claude Code Agent Registry Installer
#
# This script installs agents from the code-agents registry into your project
#
# Usage:
#   ./install.sh [options] [agent-names...]
#
# Options:
#   --all              Install all agents
#   --category <cat>   Install all agents from a category (planning|design|quality|security|infrastructure)
#   --list             List available agents
#   --commands         Also install orchestration commands
#   --target <path>    Target directory (default: current directory)
#   --help             Show this help message
#
# Examples:
#   ./install.sh --all                          # Install all agents
#   ./install.sh security-code-reviewer         # Install specific agent
#   ./install.sh --category security            # Install all security agents
#   ./install.sh --all --commands               # Install everything including commands
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
INSTALL_COMMANDS=false
REGISTRY_URL="https://raw.githubusercontent.com/skysec/code-agents/main"

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

# Function to list available agents
list_agents() {
    echo -e "\n${BLUE}Available Agents:${NC}\n"

    if [ -f "$SCRIPT_DIR/registry.json" ]; then
        # Parse using grep and sed (more portable than jq)
        echo "Planning & Requirements:"
        echo "  • product-manager              - Define product requirements and user stories"
        echo "  • project-manager              - Break down projects into implementation tasks"
        echo ""
        echo "Design & Architecture:"
        echo "  • system-architect             - Design system architecture and technology stack"
        echo ""
        echo "Code Quality:"
        echo "  • senior-code-reviewer         - Comprehensive code reviews"
        echo ""
        echo "Security:"
        echo "  • security-code-reviewer       - Security vulnerability analysis"
        echo "  • semgrep-specialist           - Create and enhance Semgrep rules"
        echo ""
        echo "Infrastructure:"
        echo "  • terraform-infrastructure-specialist - Terraform infrastructure code"
        echo ""
    else
        print_error "registry.json not found"
        exit 1
    fi
}

# Function to install a single agent
install_agent() {
    local agent_name=$1
    local agent_file=".claude/agents/${agent_name}.md"

    if [ -f "$SCRIPT_DIR/$agent_file" ]; then
        mkdir -p "$TARGET_DIR/.claude/agents"
        cp "$SCRIPT_DIR/$agent_file" "$TARGET_DIR/$agent_file"
        print_success "Installed agent: $agent_name"
        return 0
    else
        print_error "Agent not found: $agent_name"
        return 1
    fi
}

# Function to install all agents
install_all_agents() {
    print_info "Installing all agents..."
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

# Function to install agents by category
install_category() {
    local category=$1
    print_info "Installing agents from category: $category"

    case $category in
        planning)
            install_agent "product-manager"
            install_agent "project-manager"
            ;;
        design)
            install_agent "system-architect"
            ;;
        quality)
            install_agent "senior-code-reviewer"
            ;;
        security)
            install_agent "security-code-reviewer"
            install_agent "semgrep-specialist"
            ;;
        infrastructure)
            install_agent "terraform-infrastructure-specialist"
            ;;
        *)
            print_error "Unknown category: $category"
            print_info "Available categories: planning, design, quality, security, infrastructure"
            exit 1
            ;;
    esac
}

# Function to install commands
install_commands() {
    print_info "Installing orchestration commands..."
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
Claude Code Agent Registry Installer

Usage:
  $0 [options] [agent-names...]

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

Examples:
  $0 --all                          # Install all agents
  $0 security-code-reviewer         # Install specific agent
  $0 --category security            # Install all security agents
  $0 --all --commands               # Install everything
  $0 --target /path/to/repo --all   # Install to specific directory

EOF
}

# Main script
main() {
    local agents_to_install=()
    local install_all=false
    local category=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                exit 0
                ;;
            --list|-l)
                list_agents
                exit 0
                ;;
            --all|-a)
                install_all=true
                shift
                ;;
            --category|-c)
                category="$2"
                shift 2
                ;;
            --commands)
                INSTALL_COMMANDS=true
                shift
                ;;
            --target|-t)
                TARGET_DIR="$2"
                shift 2
                ;;
            *)
                agents_to_install+=("$1")
                shift
                ;;
        esac
    done

    # Print header
    echo -e "\n${BLUE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Claude Code Agent Registry Installer     ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}\n"

    # Validate target directory
    if [ ! -d "$TARGET_DIR" ]; then
        print_error "Target directory does not exist: $TARGET_DIR"
        exit 1
    fi

    print_info "Target directory: $TARGET_DIR"

    # Install agents
    if [ "$install_all" = true ]; then
        install_all_agents
    elif [ -n "$category" ]; then
        install_category "$category"
    elif [ ${#agents_to_install[@]} -gt 0 ]; then
        for agent in "${agents_to_install[@]}"; do
            install_agent "$agent"
        done
    else
        print_error "No agents specified. Use --all, --category, or specify agent names."
        echo ""
        show_help
        exit 1
    fi

    # Install commands if requested
    if [ "$INSTALL_COMMANDS" = true ]; then
        install_commands
    fi

    # Create context directory
    mkdir -p "$TARGET_DIR/.claude/context"

    # Print summary
    echo ""
    print_success "Installation complete!"
    echo ""
    print_info "Agents installed in: $TARGET_DIR/.claude/agents/"
    if [ "$INSTALL_COMMANDS" = true ]; then
        print_info "Commands installed in: $TARGET_DIR/.claude/commands/"
    fi
    echo ""
    print_info "You can now use these agents in Claude Code!"
    echo ""
}

# Run main function
main "$@"
