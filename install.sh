#!/bin/bash

# Codex CLI Installation Script with Core Provider Support
# This script builds and installs Codex CLI from source with enhanced provider features

set -e  # Exit on any error

echo "🚀 Installing Codex CLI with Core Provider support..."

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check Node.js version
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 22 or higher."
        exit 1
    fi
    
    NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 22 ]; then
        print_error "Node.js version 22 or higher is required. Current: $(node --version)"
        exit 1
    fi
    
    print_success "Node.js $(node --version) ✓"
    
    # Check/install pnpm
    if ! command -v pnpm &> /dev/null; then
        print_warning "pnpm not found. Installing pnpm..."
        npm install -g pnpm
    fi
    
    print_success "pnpm $(pnpm --version) ✓"
}

# Install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    pnpm install
    print_success "Dependencies installed ✓"
}

# Build the project
build_project() {
    print_status "Building Codex CLI..."
    cd codex-cli
    pnpm build
    cd ..
    print_success "Build completed ✓"
}

# Run tests
run_tests() {
    print_status "Running tests..."
    cd codex-cli
    if pnpm test; then
        print_success "All tests passed ✓"
    else
        print_warning "Some tests failed, but continuing installation..."
    fi
    cd ..
}

# Install globally
install_globally() {
    print_status "Installing globally..."
    cd codex-cli
    
    # Create package and install
    PACKAGE_FILE=$(npm pack --silent)
    npm install -g "$PACKAGE_FILE"
    rm "$PACKAGE_FILE"  # Clean up
    
    cd ..
    print_success "Codex CLI installed globally ✓"
}

# Setup core provider example
setup_core_provider() {
    print_status "Setting up core provider configuration example..."
    
    CODEX_DIR="$HOME/.codex"
    if [ ! -d "$CODEX_DIR" ]; then
        mkdir -p "$CODEX_DIR"
    fi
    
    # Create example config if it doesn't exist
    if [ ! -f "$CODEX_DIR/config.yaml" ]; then
        cat > "$CODEX_DIR/config.yaml" << EOF
# Codex CLI Configuration with Core Provider Support
# Edit this file to customize your setup

# Set your preferred core provider (removes OpenAI dependency)
# Options: openai, gemini, ollama, deepseek, mistral, groq, xai, openrouter, arceeai
# coreProvider: "gemini"

# Default configuration
approvalMode: "suggest"
notify: false

# History settings
history:
  maxSize: 1000
  saveHistory: true
  sensitivePatterns: []

# Shell command limits
tools:
  shell:
    maxBytes: 10240
    maxLines: 256
EOF
        print_success "Created example config at ~/.codex/config.yaml"
    else
        print_status "Configuration already exists at ~/.codex/config.yaml"
    fi
}

# Show usage information
show_usage() {
    print_success "Installation complete! 🎉"
    echo ""
    echo "📖 Quick Start Guide:"
    echo ""
    echo "1. Set up your preferred provider:"
    echo "   export CODEX_CORE_PROVIDER=gemini"
    echo "   export GEMINI_API_KEY=your_api_key_here"
    echo ""
    echo "2. Or use Ollama locally (no API key needed):"
    echo "   export CODEX_CORE_PROVIDER=ollama"
    echo ""
    echo "3. Test the installation:"
    echo "   codex --help"
    echo "   codex \"hello world\""
    echo ""
    echo "📝 Configuration:"
    echo "   - Config file: ~/.codex/config.yaml"
    echo "   - Edit config: codex --config"
    echo ""
    echo "🌟 Core Provider Features:"
    echo "   - No OpenAI dependency when using other providers"
    echo "   - Provider-specific default models"
    echo "   - Flexible configuration options"
    echo ""
    echo "📚 Documentation:"
    echo "   - BUILD_AND_INSTALL.md - Detailed build instructions"
    echo "   - CORE_PROVIDER_IMPLEMENTATION.md - Feature documentation"
    echo "   - CLAUDE.md - Development guide"
}

# Main installation flow
main() {
    echo "Codex CLI Installation Script"
    echo "=============================="
    echo ""
    
    # Check if we're in the right directory
    if [ ! -f "package.json" ] || [ ! -d "codex-cli" ]; then
        print_error "This script must be run from the root of the Codex repository."
        exit 1
    fi
    
    check_prerequisites
    install_dependencies
    build_project
    run_tests
    install_globally
    setup_core_provider
    show_usage
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Codex CLI Installation Script"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --no-tests     Skip running tests"
        echo "  --dev          Install in development mode"
        echo ""
        exit 0
        ;;
    --no-tests)
        RUN_TESTS=false
        ;;
    --dev)
        DEV_MODE=true
        ;;
    "")
        # Default behavior
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use --help for usage information."
        exit 1
        ;;
esac

# Run the installation
main