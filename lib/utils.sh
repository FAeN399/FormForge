#!/data/data/com.termux/files/usr/bin/bash

# Utility functions for FormForge

# Convert string to valid Android package/class names
sanitize_name() {
    echo "$1" | sed 's/[^a-zA-Z0-9]//g' | sed 's/^[0-9]*//'
}

# Convert to lowercase package format
to_package_name() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9.]//g'
}

# Create directory with parents
create_dir() {
    mkdir -p "$1" 2>/dev/null || {
        echo -e "${RED}Error: Cannot create directory $1${NC}"
        return 1
    }
}

# Copy template with variable substitution
process_template() {
    local template="$1"
    local output="$2"
    local -n vars=$3
    
    local content=$(cat "$template")
    
    # Replace all variables
    for key in "${!vars[@]}"; do
        content="${content//\{\{$key\}\}/${vars[$key]}}"
    done
    
    echo "$content" > "$output"
}

# Setup FormForge on first run
setup_formforge() {
    echo -e "${BLUE}${BOLD}Welcome to FormForge!${NC}"
    echo -e "Setting up for first use...\n"
    
    # Check dependencies
    echo -n "Checking dependencies... "
    local missing=()
    
    command -v git >/dev/null || missing+=("git")
    command -v java >/dev/null || missing+=("openjdk-21")
    command -v gradle >/dev/null || missing+=("gradle")
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}Missing packages${NC}"
        echo -e "Please install: ${YELLOW}pkg install ${missing[*]}${NC}"
        exit 1
    else
        echo -e "${GREEN}OK${NC}"
    fi
    
    # Create config
    cat > "$FORMFORGE_HOME/.configured" << EOF
VERSION=$VERSION
INSTALL_DATE=$(date +%Y-%m-%d)
EOF
    
    echo -e "\n${GREEN}Setup complete!${NC}"
    sleep 2
}

# Generate unique project ID
generate_project_id() {
    echo "FF$(date +%Y%m%d%H%M%S)"
}

# Mobile-friendly file picker
pick_file() {
    local dir="${1:-.}"
    local files=()
    local i=1
    
    echo -e "\n${BLUE}Select file:${NC}"
    
    while IFS= read -r file; do
        files+=("$file")
        echo "$i) $(basename "$file")"
        ((i++))
    done < <(find "$dir" -type f -name "*.template" | sort)
    
    echo -n "Choose [1-$((i-1))]: "
    read choice
    
    if [[ $choice -ge 1 && $choice -le ${#files[@]} ]]; then
        echo "${files[$((choice-1))]}"
    else
        echo ""
    fi
}

# Progress indicator for long operations
show_progress() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    
    while ps -p $pid > /dev/null 2>&1; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Validate package name
validate_package_name() {
    local package="$1"
    
    if [[ ! $package =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$ ]]; then
        echo -e "${RED}Invalid package name. Use format: com.example.app${NC}"
        return 1
    fi
    return 0
}

# Get terminal width for formatting
term_width() {
    echo "${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}"
}

# Center text
center_text() {
    local text="$1"
    local width=$(term_width)
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%${padding}s%s\n" "" "$text"
}

# Create a horizontal line
hr() {
    printf '%*s\n' "$(term_width)" '' | tr ' ' "${1:--}"
}

# Safe read with default
read_with_default() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"
    
    read -p "$prompt [$default]: " value
    value="${value:-$default}"
    eval "$var_name='$value'"
}