#!/bin/bash
#
# Agent Info Tool
# Get detailed information about a specific agent
#
# Usage:
#   ./info.sh <agent-name>
#

set -e

REGISTRY_FILE="registry.json"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

# Check if jq is available
HAS_JQ=false
if command -v jq &> /dev/null; then
    HAS_JQ=true
fi

# Show agent info with jq
show_info_jq() {
    local agent_name=$1

    # Check if agent exists
    local exists=$(jq -r ".agents[] | select(.name == \"$agent_name\") | .name" "$REGISTRY_FILE")

    if [ -z "$exists" ]; then
        echo -e "${YELLOW}Agent not found: $agent_name${NC}"
        echo ""
        echo "Try: ./search.sh --all"
        exit 1
    fi

    # Extract agent data
    local name=$(jq -r ".agents[] | select(.name == \"$agent_name\") | .name" "$REGISTRY_FILE")
    local version=$(jq -r ".agents[] | select(.name == \"$agent_name\") | .version" "$REGISTRY_FILE")
    local category=$(jq -r ".agents[] | select(.name == \"$agent_name\") | .category" "$REGISTRY_FILE")
    local description=$(jq -r ".agents[] | select(.name == \"$agent_name\") | .description" "$REGISTRY_FILE")
    local file=$(jq -r ".agents[] | select(.name == \"$agent_name\") | .file" "$REGISTRY_FILE")

    # Print header
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ${GREEN}${name}${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
    echo ""

    # Print details
    echo -e "${CYAN}Version:${NC}     ${version}"
    echo -e "${CYAN}Category:${NC}    ${category}"
    echo -e "${CYAN}File:${NC}        ${file}"
    echo ""
    echo -e "${CYAN}Description:${NC}"
    echo -e "  ${description}"
    echo ""

    # Print use cases
    echo -e "${CYAN}Use Cases:${NC}"
    jq -r ".agents[] | select(.name == \"$agent_name\") | .use_cases[]" "$REGISTRY_FILE" | while read -r use_case; do
        echo -e "  ${GREEN}•${NC} ${use_case}"
    done
    echo ""

    # Print tools
    echo -e "${CYAN}Available Tools:${NC}"
    local tool_count=$(jq -r ".agents[] | select(.name == \"$agent_name\") | .tools | length" "$REGISTRY_FILE")
    echo -e "  ${GRAY}${tool_count} tools available${NC}"
    jq -r ".agents[] | select(.name == \"$agent_name\") | .tools[]" "$REGISTRY_FILE" | head -10 | while read -r tool; do
        echo -e "    - ${tool}"
    done

    if [ "$tool_count" -gt 10 ]; then
        echo -e "    ${GRAY}... and $((tool_count - 10)) more${NC}"
    fi
    echo ""

    # Installation
    echo -e "${CYAN}Installation:${NC}"
    echo -e "  ${GRAY}\$ ./install.sh ${name}${NC}"
    echo ""

    # File location
    if [ -f "$file" ]; then
        echo -e "${CYAN}Agent Definition:${NC}"
        echo -e "  ${GRAY}${file}${NC}"
        echo ""

        # Show first few lines of the agent
        echo -e "${CYAN}Preview:${NC}"
        echo -e "${GRAY}─────────────────────────────────────────────${NC}"
        head -20 "$file" | sed 's/^/  /'
        echo -e "${GRAY}─────────────────────────────────────────────${NC}"
        echo ""
    fi
}

# Show info without jq (limited)
show_info_basic() {
    local agent_name=$1

    echo -e "${YELLOW}Install 'jq' for detailed agent information${NC}"
    echo ""
    echo -e "Searching for: ${agent_name}"
    grep -i "$agent_name" "$REGISTRY_FILE" -A 10 | head -20
}

# Main
main() {
    if [ ! -f "$REGISTRY_FILE" ]; then
        echo "Error: registry.json not found"
        exit 1
    fi

    if [ -z "${1:-}" ]; then
        echo "Usage: $0 <agent-name>"
        echo ""
        echo "Examples:"
        echo "  $0 security-code-reviewer"
        echo "  $0 system-architect"
        echo ""
        echo "To see all agents: ./search.sh --all"
        exit 1
    fi

    if [ "$HAS_JQ" = true ]; then
        show_info_jq "$1"
    else
        show_info_basic "$1"
    fi
}

main "$@"
