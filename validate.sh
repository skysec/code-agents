#!/bin/bash
#
# Validation Script for Claude Code Agent Marketplace
#
# Validates both:
# 1. Official Claude Code marketplace format (.claude-plugin/)
# 2. Custom agent registry format (registry.json)
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_header() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

ERRORS=0
WARNINGS=0

# Check if jq is available
HAS_JQ=false
if command -v jq &> /dev/null; then
    HAS_JQ=true
else
    print_warning "jq not installed - some validations will be skipped"
    print_info "Install: apt-get install jq (Ubuntu) or brew install jq (macOS)"
fi

#
# Validate Official Claude Code Marketplace Format
#
print_header "Validating Official Claude Code Marketplace Format"

# 1. Check .claude-plugin directory exists
if [ -d ".claude-plugin" ]; then
    print_success ".claude-plugin/ directory exists"
else
    print_error ".claude-plugin/ directory missing"
    ((ERRORS++))
fi

# 2. Validate plugin.json
if [ -f ".claude-plugin/plugin.json" ]; then
    print_success ".claude-plugin/plugin.json exists"

    if [ "$HAS_JQ" = true ]; then
        # Validate JSON syntax
        if jq empty .claude-plugin/plugin.json 2>/dev/null; then
            print_success "plugin.json is valid JSON"

            # Check required fields
            name=$(jq -r '.name // empty' .claude-plugin/plugin.json)
            if [ -n "$name" ]; then
                print_success "plugin.json has 'name' field: $name"

                # Validate kebab-case
                if [[ $name =~ ^[a-z][a-z0-9]*(-[a-z0-9]+)*$ ]]; then
                    print_success "Plugin name is in kebab-case format"
                else
                    print_error "Plugin name must be in kebab-case (lowercase with hyphens)"
                    ((ERRORS++))
                fi
            else
                print_error "plugin.json missing required 'name' field"
                ((ERRORS++))
            fi

            # Check recommended fields
            version=$(jq -r '.version // empty' .claude-plugin/plugin.json)
            [ -n "$version" ] && print_success "Has version: $version" || print_warning "Missing version field"

            desc=$(jq -r '.description // empty' .claude-plugin/plugin.json)
            [ -n "$desc" ] && print_success "Has description" || print_warning "Missing description"

            # Check component paths
            agents=$(jq -r '.agents // empty' .claude-plugin/plugin.json)
            [ -n "$agents" ] && print_success "Agents path configured: $agents"

            commands=$(jq -r '.commands // empty' .claude-plugin/plugin.json)
            [ -n "$commands" ] && print_success "Commands path configured: $commands"

        else
            print_error "plugin.json is invalid JSON"
            ((ERRORS++))
        fi
    fi
else
    print_error ".claude-plugin/plugin.json missing"
    ((ERRORS++))
fi

# 3. Validate marketplace.json
if [ -f ".claude-plugin/marketplace.json" ]; then
    print_success ".claude-plugin/marketplace.json exists"

    if [ "$HAS_JQ" = true ]; then
        if jq empty .claude-plugin/marketplace.json 2>/dev/null; then
            print_success "marketplace.json is valid JSON"

            # Check required fields
            plugins_count=$(jq '.plugins | length' .claude-plugin/marketplace.json)
            print_success "Contains $plugins_count plugin(s)"

            # Validate each plugin entry
            jq -r '.plugins[] | .name' .claude-plugin/marketplace.json | while read -r plugin_name; do
                print_info "Plugin: $plugin_name"
            done
        else
            print_error "marketplace.json is invalid JSON"
            ((ERRORS++))
        fi
    fi
else
    print_warning ".claude-plugin/marketplace.json missing (optional for single plugins)"
fi

# 4. Check agent directory structure
print_header "Validating Agent Directory Structure"

if [ -d ".claude/agents" ]; then
    print_success ".claude/agents/ directory exists"

    agent_count=$(find .claude/agents -name "*.md" | wc -l)
    print_success "Found $agent_count agent definition(s)"

    # Validate each agent file
    for agent_file in .claude/agents/*.md; do
        if [ -f "$agent_file" ]; then
            agent_name=$(basename "$agent_file" .md)

            # Check YAML frontmatter
            if head -1 "$agent_file" | grep -q "^---$"; then
                print_success "Agent '$agent_name' has YAML frontmatter"

                # Extract frontmatter and validate
                frontmatter=$(sed -n '/^---$/,/^---$/p' "$agent_file" | sed '1d;$d')

                # Check required fields in frontmatter
                if echo "$frontmatter" | grep -q "^name:"; then
                    print_success "  - Has 'name' field"
                else
                    print_error "  - Missing 'name' field"
                    ((ERRORS++))
                fi

                if echo "$frontmatter" | grep -q "^description:"; then
                    print_success "  - Has 'description' field"
                else
                    print_warning "  - Missing 'description' field"
                    ((WARNINGS++))
                fi

                if echo "$frontmatter" | grep -q "^tools:"; then
                    print_success "  - Has 'tools' field"
                else
                    print_warning "  - Missing 'tools' field"
                    ((WARNINGS++))
                fi

            else
                print_error "Agent '$agent_name' missing YAML frontmatter"
                ((ERRORS++))
            fi
        fi
    done
else
    print_error ".claude/agents/ directory missing"
    ((ERRORS++))
fi

# 5. Check commands directory
if [ -d ".claude/commands" ]; then
    print_success ".claude/commands/ directory exists"

    command_count=$(find .claude/commands -name "*.md" | wc -l)
    print_success "Found $command_count command(s)"
else
    print_info ".claude/commands/ directory not present (optional)"
fi

#
# Validate Custom Registry Format
#
print_header "Validating Custom Registry Format"

if [ -f "registry.json" ]; then
    print_success "registry.json exists"

    if [ "$HAS_JQ" = true ]; then
        if jq empty registry.json 2>/dev/null; then
            print_success "registry.json is valid JSON"

            # Validate structure
            registry_agents=$(jq '.agents | length' registry.json)
            print_success "Registry contains $registry_agents agent entries"

            # Check each agent has required fields
            jq -r '.agents[] | .name' registry.json | while read -r agent_name; do
                agent_data=$(jq ".agents[] | select(.name == \"$agent_name\")" registry.json)

                has_version=$(echo "$agent_data" | jq -r '.version // empty')
                has_category=$(echo "$agent_data" | jq -r '.category // empty')
                has_file=$(echo "$agent_data" | jq -r '.file // empty')

                if [ -n "$has_version" ] && [ -n "$has_category" ] && [ -n "$has_file" ]; then
                    print_success "Agent '$agent_name' has all required registry fields"
                else
                    print_error "Agent '$agent_name' missing required registry fields"
                    ((ERRORS++))
                fi
            done

            # Check categories defined
            if jq -e '.categories' registry.json > /dev/null 2>&1; then
                print_success "Categories defined in registry"
            else
                print_warning "No categories defined"
                ((WARNINGS++))
            fi

        else
            print_error "registry.json is invalid JSON"
            ((ERRORS++))
        fi
    fi
else
    print_error "registry.json missing"
    ((ERRORS++))
fi

#
# Check Installation Scripts
#
print_header "Validating Installation Scripts"

[ -f "install.sh" ] && [ -x "install.sh" ] && print_success "install.sh exists and is executable" || {
    print_error "install.sh missing or not executable"
    ((ERRORS++))
}

[ -f "search.sh" ] && [ -x "search.sh" ] && print_success "search.sh exists and is executable" || {
    print_warning "search.sh missing or not executable"
    ((WARNINGS++))
}

[ -f "info.sh" ] && [ -x "info.sh" ] && print_success "info.sh exists and is executable" || {
    print_warning "info.sh missing or not executable"
    ((WARNINGS++))
}

[ -f "version.sh" ] && [ -x "version.sh" ] && print_success "version.sh exists and is executable" || {
    print_warning "version.sh missing or not executable"
    ((WARNINGS++))
}

#
# Check Documentation
#
print_header "Validating Documentation"

[ -f "README.md" ] && print_success "README.md exists" || {
    print_error "README.md missing"
    ((ERRORS++))
}

[ -f "CHANGELOG.md" ] && print_success "CHANGELOG.md exists" || {
    print_warning "CHANGELOG.md missing"
    ((WARNINGS++))
}

[ -f "ROADMAP.md" ] && print_success "ROADMAP.md exists" || {
    print_info "ROADMAP.md not present"
}

[ -f "USAGE_EXAMPLES.md" ] && print_success "USAGE_EXAMPLES.md exists" || {
    print_info "USAGE_EXAMPLES.md not present"
}

#
# Summary
#
print_header "Validation Summary"

if [ $ERRORS -eq 0 ]; then
    print_success "All critical validations passed!"
else
    print_error "Found $ERRORS error(s)"
fi

if [ $WARNINGS -gt 0 ]; then
    print_warning "Found $WARNINGS warning(s)"
fi

echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ Repository is valid for Claude Code Marketplace${NC}"
    exit 0
else
    echo -e "${RED}✗ Repository has validation errors${NC}"
    exit 1
fi
