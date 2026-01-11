#!/bin/bash
#
# Agent Search Tool
# Search the agent registry by keyword
#
# Usage:
#   ./search.sh <keyword>
#   ./search.sh --category <category>
#   ./search.sh --all
#

set -e

REGISTRY_FILE="registry.json"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
GRAY='\033[0;90m'
NC='\033[0m'

# Check if jq is available
HAS_JQ=false
if command -v jq &> /dev/null; then
    HAS_JQ=true
fi

# Print agent result
print_agent() {
    local name=$1
    local desc=$2
    local category=$3
    local version=$4

    echo -e "${GREEN}●${NC} ${BLUE}${name}${NC} ${GRAY}(v${version})${NC}"
    echo -e "  ${category} | ${desc}"
    echo ""
}

# Search with jq (better)
search_with_jq() {
    local keyword=$1

    if [ -z "$keyword" ]; then
        # List all
        jq -r '.agents[] | "\(.name)|\(.description)|\(.category)|\(.version)"' "$REGISTRY_FILE" | while IFS='|' read -r name desc cat ver; do
            print_agent "$name" "$desc" "$cat" "$ver"
        done
    else
        # Search by keyword
        jq -r ".agents[] | select(.name | contains(\"$keyword\")) | \"\(.name)|\(.description)|\(.category)|\(.version)\"" "$REGISTRY_FILE" | while IFS='|' read -r name desc cat ver; do
            print_agent "$name" "$desc" "$cat" "$ver"
        done

        # Also search in description
        jq -r ".agents[] | select(.description | contains(\"$keyword\")) | \"\(.name)|\(.description)|\(.category)|\(.version)\"" "$REGISTRY_FILE" | while IFS='|' read -r name desc cat ver; do
            print_agent "$name" "$desc" "$cat" "$ver"
        done
    fi
}

# Search without jq (fallback)
search_without_jq() {
    local keyword=$1

    echo -e "${YELLOW}Note: Install 'jq' for better search results${NC}\n"

    if [ -z "$keyword" ]; then
        grep -E '"name"|"description"' "$REGISTRY_FILE" | sed 's/[",]//g' | sed 's/^[[:space:]]*//'
    else
        grep -i "$keyword" "$REGISTRY_FILE" -B 2 -A 2
    fi
}

# Search by category
search_by_category() {
    local category=$1

    echo -e "${BLUE}Agents in category: ${category}${NC}\n"

    if [ "$HAS_JQ" = true ]; then
        jq -r ".agents[] | select(.category == \"$category\") | \"\(.name)|\(.description)|\(.category)|\(.version)\"" "$REGISTRY_FILE" | while IFS='|' read -r name desc cat ver; do
            print_agent "$name" "$desc" "$cat" "$ver"
        done
    else
        echo -e "${YELLOW}Install 'jq' for category search${NC}"
        exit 1
    fi
}

# Show categories
show_categories() {
    echo -e "${BLUE}Available Categories:${NC}\n"

    if [ "$HAS_JQ" = true ]; then
        jq -r '.categories | to_entries[] | "\(.key): \(.value.description)"' "$REGISTRY_FILE" | while IFS=':' read -r cat desc; do
            echo -e "${GREEN}●${NC} ${BLUE}${cat}${NC}${desc}"
        done
    else
        echo "  planning, design, quality, security, infrastructure"
    fi
    echo ""
}

# Main
main() {
    if [ ! -f "$REGISTRY_FILE" ]; then
        echo "Error: registry.json not found"
        exit 1
    fi

    case "${1:-}" in
        --category|-c)
            if [ -z "${2:-}" ]; then
                show_categories
            else
                search_by_category "$2"
            fi
            ;;
        --all|-a)
            echo -e "${BLUE}All Available Agents:${NC}\n"
            if [ "$HAS_JQ" = true ]; then
                search_with_jq ""
            else
                search_without_jq ""
            fi
            ;;
        --categories)
            show_categories
            ;;
        --help|-h)
            cat << EOF
Agent Search Tool

Usage:
  $0 <keyword>              Search for agents by keyword
  $0 --all                  List all agents
  $0 --category <name>      List agents in category
  $0 --categories           Show all categories
  $0 --help                 Show this help

Examples:
  $0 security               # Find security-related agents
  $0 --category planning    # Show all planning agents
  $0 --all                  # List everything

EOF
            ;;
        "")
            echo "Usage: $0 <keyword> or $0 --all"
            echo "Try: $0 --help"
            ;;
        *)
            echo -e "${BLUE}Searching for: ${1}${NC}\n"
            if [ "$HAS_JQ" = true ]; then
                search_with_jq "$1"
            else
                search_without_jq "$1"
            fi
            ;;
    esac
}

main "$@"
