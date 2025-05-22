# Build and Installation Guide

This guide covers how to compile, build, and install the Codex CLI with the new **Core Provider** features.

## Prerequisites

### System Requirements

- **Node.js**: Version 22 or higher
- **Package Manager**: pnpm (preferred) or npm
- **Rust** (optional, for Rust components): 1.70 or higher
- **Operating System**: macOS, Linux, or Windows

### Install Dependencies

#### Install Node.js (if not already installed)

```bash
# Using Node Version Manager (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
nvm install 22
nvm use 22

# Or download from https://nodejs.org/
```

#### Install pnpm (package manager)

```bash
npm install -g pnpm
```

#### Install Rust (optional, for experimental Rust components)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

## Quick Installation (Pre-built)

### Option 1: Install from npm (Original Package)

```bash
# Install the official package
npm install -g @openai/codex
```

**Note**: This installs the original version without the core provider features.

### Option 2: Install from Source (With Core Provider Features)

Follow the "Build from Source" section below to get the enhanced version with core provider support.

## Build from Source

### 1. Clone the Repository

```bash
git clone <repository-url>
cd codex
```

### 2. Install Dependencies

```bash
# Install all workspace dependencies
pnpm install
```

### 3. Build TypeScript Components

#### Development Build

```bash
# Build for development (with source maps)
cd codex-cli
pnpm build:dev
```

#### Production Build

```bash
# Build for production (optimized)
cd codex-cli
pnpm build
```

### 4. Build Rust Components (Optional)

The Rust implementation is experimental but provides additional features:

```bash
cd codex-rs

# Build all Rust components
cargo build --release

# Install TUI component globally
just install
# or manually:
cargo install --path tui
```

### 5. Test the Build

```bash
# Run TypeScript tests
cd codex-cli
pnpm test

# Run Rust tests
cd codex-rs
cargo test

# Type checking
cd codex-cli
pnpm typecheck

# Linting
cd codex-cli
pnpm lint
```

## Installation Methods

### Method 1: Local Development Installation

```bash
cd codex-cli

# Link for development
npm link

# Now you can use 'codex' command globally
codex --help
```

### Method 2: Global Package Installation

```bash
cd codex-cli

# Pack the package
npm pack

# Install the packed version globally
npm install -g openai-codex-*.tgz
```

### Method 3: Direct Execution

```bash
cd codex-cli

# Run directly from build output
node dist/cli.js --help
```

## Verification

### Test Basic Functionality

```bash
# Check version
codex --version

# Test help
codex --help

# Test configuration (should create ~/.codex/config.json if not exists)
codex --config
```

### Test Core Provider Features

#### Set a Non-OpenAI Core Provider

```bash
# Method 1: Environment variable
export CODEX_CORE_PROVIDER=gemini
export GEMINI_API_KEY=your_api_key_here

# Method 2: Configuration file
echo 'coreProvider: "gemini"' >> ~/.codex/config.yaml

# Test that it works without OPENAI_API_KEY
unset OPENAI_API_KEY
codex "hello world"  # Should use Gemini, not fail with OpenAI error
```

## Configuration for Core Provider Features

### Basic Setup with Gemini

```bash
# 1. Set core provider
export CODEX_CORE_PROVIDER=gemini

# 2. Set Gemini API key
export GEMINI_API_KEY=your_gemini_api_key_here

# 3. Test
codex "explain this function"
```

### Basic Setup with Ollama (Local)

```bash
# 1. Install and start Ollama
# Download from https://ollama.ai/

# 2. Set core provider
export CODEX_CORE_PROVIDER=ollama

# 3. Test (no API key needed for local Ollama)
codex "help me debug this code"
```

### Configuration File Setup

```yaml
# ~/.codex/config.yaml
coreProvider: "deepseek"

# Provider-specific settings
providers:
  custom-ollama:
    name: "Custom Ollama"
    baseURL: "http://localhost:11434/v1"
    envKey: "OLLAMA_API_KEY"

# Other settings
approvalMode: "suggest"
notify: true
```

## Development Workflow

### Making Changes

```bash
# 1. Make your changes to src/ files

# 2. Rebuild
cd codex-cli
pnpm build

# 3. Test
pnpm test
pnpm typecheck
pnpm lint

# 4. Test manually
node dist/cli.js your-test-command
```

### Hot Reload Development

```bash
cd codex-cli

# Watch mode for TypeScript compilation
pnpm dev  # Runs tsc --watch

# In another terminal, test changes
node dist/cli-dev.js --help
```

## Build Artifacts

### TypeScript Build Output

- **Location**: `codex-cli/dist/`
- **Main executable**: `dist/cli.js`
- **Development build**: `dist/cli-dev.js`
- **Binary wrapper**: `bin/codex.js`

### Rust Build Output

- **Location**: `codex-rs/target/release/`
- **TUI executable**: `target/release/codex-tui`
- **CLI executable**: `target/release/codex-cli`

## Troubleshooting

### Common Build Issues

#### Node.js Version

```bash
# Error: "Codex CLI requires Node.js version 22 or newer"
node --version  # Check version
nvm install 22  # Upgrade if needed
```

#### Missing Dependencies

```bash
# Error: "pnpm: command not found"
npm install -g pnpm

# Error: "Module not found"
pnpm install  # Reinstall dependencies
```

#### TypeScript Errors

```bash
# Check for type errors
cd codex-cli
pnpm typecheck

# Fix common issues
rm -rf node_modules
pnpm install
```

#### Permission Issues

```bash
# If npm link fails with permissions
sudo npm link  # macOS/Linux
# Or use npm config to change global directory
```

### Core Provider Issues

#### API Key Not Found

```bash
# Verify environment variables
echo $CODEX_CORE_PROVIDER
echo $GEMINI_API_KEY  # or your provider's key

# Check config file
cat ~/.codex/config.yaml
```

#### Provider Not Supported

```bash
# List available providers
codex --help  # Check provider list in help text

# Use supported provider names:
# openai, gemini, ollama, deepseek, mistral, groq, xai, openrouter, arceeai
```

## Platform-Specific Notes

### macOS

- Apple Seatbelt sandboxing is automatically configured
- XCode Command Line Tools may be required for some dependencies

### Linux

- Landlock filesystem restrictions are used for sandboxing
- Docker may be required for additional isolation

### Windows

- Windows Subsystem for Linux (WSL) is recommended
- Some Unix-specific features may not work natively

## Advanced Build Options

### Custom Build Configuration

```bash
# Development build with source maps
NODE_ENV=development pnpm build

# Production build with optimizations
NODE_ENV=production pnpm build

# Build with custom output directory
OUT_DIR=custom-dist pnpm build
```

### Rust Cross-Compilation

```bash
cd codex-rs

# Build for different targets
cargo build --release --target x86_64-unknown-linux-gnu
cargo build --release --target aarch64-apple-darwin
```

### Container Build

```bash
# Build in Docker container (if supported)
cd codex-cli
./scripts/build_container.sh

# Run in container
./scripts/run_in_container.sh
```

## Distribution

### Creating Release Package

```bash
cd codex-cli

# Create distribution package
pnpm build
npm pack

# This creates: openai-codex-X.X.X.tgz
```

### Local Installation of Built Package

```bash
# Install your custom build globally
npm install -g ./openai-codex-*.tgz

# Or install for specific project
cd your-project
npm install /path/to/codex/codex-cli/openai-codex-*.tgz
```

---

## Summary

The enhanced Codex CLI with core provider features can be built and installed using standard Node.js/pnpm tooling. The key benefits of building from source include:

1. **Core Provider Support** - Use any supported LLM provider as default
2. **No OpenAI Dependency** - Completely avoid OpenAI when using other providers
3. **Latest Features** - Access to the newest functionality
4. **Customization** - Ability to modify and extend the codebase

For most users, the build process is:

```bash
git clone <repo> && cd codex
pnpm install
cd codex-cli && pnpm build
npm link  # or npm pack && npm install -g *.tgz
```
