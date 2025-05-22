# Core Provider Feature

🎯 **Eliminate OpenAI dependency** - Use any LLM provider without requiring OpenAI API keys

## Quick Setup

### 1. Install Enhanced Codex CLI

```bash
# Clone and build from source (see BUILD_AND_INSTALL.md for details)
git clone <repo> && cd codex
./install.sh
```

### 2. Configure Your Preferred Provider

#### Option A: Gemini (Google)

```bash
export CODEX_CORE_PROVIDER=gemini
export GEMINI_API_KEY=your_gemini_api_key
codex "help me debug this function"
```

#### Option B: Ollama (Local)

```bash
export CODEX_CORE_PROVIDER=ollama
# No API key needed for local Ollama
codex "explain this code"
```

#### Option C: DeepSeek

```bash
export CODEX_CORE_PROVIDER=deepseek
export DEEPSEEK_API_KEY=your_deepseek_api_key
codex "refactor this function"
```

#### Option D: Configuration File

```yaml
# ~/.codex/config.yaml
coreProvider: "gemini"
```

## Benefits

✅ **No OpenAI Lock-in** - Use any provider without OpenAI fallback  
✅ **Smart Defaults** - Each provider gets appropriate default models  
✅ **Backward Compatible** - Existing configs continue to work  
✅ **Multiple Options** - Environment variables, config files, or CLI flags

## Supported Providers

| Provider   | Default Agentic Model       | Default Full Context Model  |
| ---------- | --------------------------- | --------------------------- |
| openai     | codex-mini-latest           | gpt-4.1                     |
| gemini     | gemini-1.5-flash            | gemini-1.5-pro              |
| ollama     | llama3.2:latest             | llama3.2:latest             |
| deepseek   | deepseek-chat               | deepseek-reasoner           |
| mistral    | mistral-small-latest        | mistral-large-latest        |
| groq       | llama-3.3-70b-versatile     | llama-3.3-70b-versatile     |
| xai        | grok-beta                   | grok-beta                   |
| openrouter | anthropic/claude-3.5-sonnet | anthropic/claude-3.5-sonnet |

## Configuration Examples

### Complete YAML Config

```yaml
# ~/.codex/config.yaml
coreProvider: "gemini"
approvalMode: "suggest"
notify: true

providers:
  custom-ollama:
    name: "Custom Ollama"
    baseURL: "http://localhost:11434/v1"
    envKey: "OLLAMA_API_KEY"

history:
  maxSize: 1000
  saveHistory: true
```

### JSON Config

```json
{
  "coreProvider": "deepseek",
  "approvalMode": "suggest"
}
```

### Environment Variables

```bash
# Set core provider
export CODEX_CORE_PROVIDER=gemini

# Set provider API key
export GEMINI_API_KEY=your_key_here

# Override per session
codex --provider openai "use OpenAI for this request"
```

## Migration Guide

### Before (Required OpenAI)

```bash
export OPENAI_API_KEY=required_even_for_other_providers
export GEMINI_API_KEY=your_gemini_key
codex --provider gemini "help me code"
```

### After (No OpenAI Required)

```bash
export CODEX_CORE_PROVIDER=gemini
export GEMINI_API_KEY=your_gemini_key
codex "help me code"  # Uses Gemini by default
```

## Advanced Usage

### Multiple Provider Setup

```yaml
# ~/.codex/config.yaml
coreProvider: "ollama" # Local development default

providers:
  production-gemini:
    name: "Production Gemini"
    baseURL: "https://generativelanguage.googleapis.com/v1beta/openai"
    envKey: "PROD_GEMINI_API_KEY"
```

### Per-Project Configuration

```bash
# In project root
echo 'coreProvider: "deepseek"' > .codex.env
export DEEPSEEK_API_KEY=project_specific_key
```

## Troubleshooting

### Provider Not Working

```bash
# Check core provider setting
echo $CODEX_CORE_PROVIDER

# Verify API key
echo $GEMINI_API_KEY  # or your provider's key

# Test with explicit provider
codex --provider gemini "test"
```

### Still Asking for OpenAI Key

```bash
# Make sure you're using the enhanced version
codex --version

# Set core provider explicitly
export CODEX_CORE_PROVIDER=your_preferred_provider
```

---

**📖 Full Documentation**:

- `BUILD_AND_INSTALL.md` - Complete build instructions
- `CORE_PROVIDER_IMPLEMENTATION.md` - Technical implementation details
- `CLAUDE.md` - Development and architecture guide
