#!/bin/bash
#
# Version Management Script for Claude Code Agent Registry
#
# Usage:
#   ./version.sh current                    # Show current version
#   ./version.sh bump <major|minor|patch>   # Bump version
#   ./version.sh list-agents                # List all agent versions
#   ./version.sh bump-agent <name> <type>   # Bump specific agent version
#   ./version.sh validate                   # Validate registry.json
#

set -e

REGISTRY_FILE="registry.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Helper functions
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

# Check if jq is available, otherwise use grep/sed
HAS_JQ=false
if command -v jq &> /dev/null; then
    HAS_JQ=true
fi

# Get current registry version
get_current_version() {
    if [ "$HAS_JQ" = true ]; then
        jq -r '.version' "$REGISTRY_FILE"
    else
        grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "$REGISTRY_FILE" | head -1 | sed 's/.*"\([0-9.]*\)".*/\1/'
    fi
}

# Parse version into major, minor, patch
parse_version() {
    local version=$1
    IFS='.' read -r MAJOR MINOR PATCH <<< "$version"
}

# Bump version
bump_version() {
    local bump_type=$1
    local current=$(get_current_version)

    parse_version "$current"

    case $bump_type in
        major)
            MAJOR=$((MAJOR + 1))
            MINOR=0
            PATCH=0
            ;;
        minor)
            MINOR=$((MINOR + 1))
            PATCH=0
            ;;
        patch)
            PATCH=$((PATCH + 1))
            ;;
        *)
            print_error "Invalid bump type: $bump_type"
            print_info "Use: major, minor, or patch"
            exit 1
            ;;
    esac

    local new_version="${MAJOR}.${MINOR}.${PATCH}"

    # Update registry.json
    if [ "$HAS_JQ" = true ]; then
        jq ".version = \"$new_version\"" "$REGISTRY_FILE" > "${REGISTRY_FILE}.tmp"
        mv "${REGISTRY_FILE}.tmp" "$REGISTRY_FILE"
    else
        sed -i "s/\"version\"[[:space:]]*:[[:space:]]*\"[^\"]*\"/\"version\": \"$new_version\"/" "$REGISTRY_FILE"
    fi

    print_success "Bumped version: $current → $new_version"
    print_info "Don't forget to:"
    echo "  1. Update CHANGELOG.md"
    echo "  2. Commit changes: git add registry.json CHANGELOG.md"
    echo "  3. Create tag: git tag -a v$new_version -m 'Release v$new_version'"
    echo "  4. Push: git push origin main --tags"
}

# List all agent versions
list_agent_versions() {
    echo -e "\n${BLUE}Agent Versions:${NC}\n"

    if [ "$HAS_JQ" = true ]; then
        jq -r '.agents[] | "\(.name): \(.version) (\(.category))"' "$REGISTRY_FILE" | while read -r line; do
            echo "  • $line"
        done
    else
        print_warning "Install 'jq' for better formatting"
        grep -A 3 '"name":' "$REGISTRY_FILE" | grep -E '"name"|"version"' | sed 's/[",]//g' | sed 's/^[[:space:]]*//'
    fi
    echo ""
}

# Bump specific agent version
bump_agent_version() {
    local agent_name=$1
    local bump_type=$2

    if [ -z "$agent_name" ] || [ -z "$bump_type" ]; then
        print_error "Usage: $0 bump-agent <agent-name> <major|minor|patch>"
        exit 1
    fi

    if [ "$HAS_JQ" = true ]; then
        # Get current agent version
        local current=$(jq -r ".agents[] | select(.name == \"$agent_name\") | .version" "$REGISTRY_FILE")

        if [ -z "$current" ] || [ "$current" = "null" ]; then
            print_error "Agent not found: $agent_name"
            exit 1
        fi

        parse_version "$current"

        case $bump_type in
            major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
            minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
            patch) PATCH=$((PATCH + 1)) ;;
            *)
                print_error "Invalid bump type: $bump_type"
                exit 1
                ;;
        esac

        local new_version="${MAJOR}.${MINOR}.${PATCH}"

        # Update agent version in registry.json
        jq "(.agents[] | select(.name == \"$agent_name\") | .version) = \"$new_version\"" "$REGISTRY_FILE" > "${REGISTRY_FILE}.tmp"
        mv "${REGISTRY_FILE}.tmp" "$REGISTRY_FILE"

        print_success "Bumped $agent_name: $current → $new_version"
    else
        print_error "Agent version bumping requires 'jq'. Please install it:"
        echo "  Ubuntu/Debian: apt-get install jq"
        echo "  macOS: brew install jq"
        exit 1
    fi
}

# Validate registry.json
validate_registry() {
    print_info "Validating registry.json..."

    if [ "$HAS_JQ" = true ]; then
        if jq empty "$REGISTRY_FILE" 2>/dev/null; then
            print_success "registry.json is valid JSON"

            # Check required fields
            local has_name=$(jq -e '.name' "$REGISTRY_FILE" > /dev/null 2>&1 && echo "yes" || echo "no")
            local has_version=$(jq -e '.version' "$REGISTRY_FILE" > /dev/null 2>&1 && echo "yes" || echo "no")
            local has_agents=$(jq -e '.agents' "$REGISTRY_FILE" > /dev/null 2>&1 && echo "yes" || echo "no")

            [ "$has_name" = "yes" ] && print_success "✓ Has registry name" || print_error "✗ Missing registry name"
            [ "$has_version" = "yes" ] && print_success "✓ Has version" || print_error "✗ Missing version"
            [ "$has_agents" = "yes" ] && print_success "✓ Has agents array" || print_error "✗ Missing agents array"

            # Count agents
            local agent_count=$(jq '.agents | length' "$REGISTRY_FILE")
            print_info "Total agents: $agent_count"

        else
            print_error "registry.json is invalid JSON"
            exit 1
        fi
    else
        # Basic validation without jq
        if grep -q '"name"' "$REGISTRY_FILE" && grep -q '"version"' "$REGISTRY_FILE"; then
            print_success "registry.json appears valid (install 'jq' for thorough validation)"
        else
            print_error "registry.json may be invalid"
            exit 1
        fi
    fi
}

# Show current version
show_current() {
    local version=$(get_current_version)
    echo -e "\n${BLUE}Current Registry Version:${NC} ${GREEN}v$version${NC}\n"
}

# Show help
show_help() {
    cat << EOF
Version Management Script for Claude Code Agent Registry

Usage:
  $0 <command> [options]

Commands:
  current                        Show current registry version
  bump <major|minor|patch>       Bump registry version
  list-agents                    List all agent versions
  bump-agent <name> <type>       Bump specific agent version
  validate                       Validate registry.json structure
  help                           Show this help message

Examples:
  $0 current
  $0 bump minor
  $0 list-agents
  $0 bump-agent security-code-reviewer patch
  $0 validate

Version Types:
  major    Breaking changes (1.0.0 → 2.0.0)
  minor    New features (1.0.0 → 1.1.0)
  patch    Bug fixes (1.0.0 → 1.0.1)

EOF
}

# Main
main() {
    if [ ! -f "$REGISTRY_FILE" ]; then
        print_error "registry.json not found"
        exit 1
    fi

    case "${1:-}" in
        current)
            show_current
            ;;
        bump)
            bump_version "${2:-}"
            ;;
        list-agents|list)
            list_agent_versions
            ;;
        bump-agent)
            bump_agent_version "${2:-}" "${3:-}"
            ;;
        validate)
            validate_registry
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: ${1:-}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
