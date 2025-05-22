# Core Provider Implementation

This document describes the implementation of the **Core Provider** feature that eliminates Codex's dependency on OpenAI as a fallback provider.

## Problem Statement

Previously, Codex would always fall back to `OPENAI_API_KEY` even when using other providers, creating an unwanted dependency on OpenAI. The system also used hard-coded OpenAI models (`codex-mini-latest`, `gpt-4.1`) as defaults regardless of the configured provider.

## Solution Overview

The implementation adds:

1. **Core Provider Configuration**: Set a default provider that doesn't fall back to OpenAI
2. **Provider-Specific Default Models**: Each provider has appropriate default models
3. **Configurable API Key Behavior**: Choose whether to fall back to OpenAI or not
4. **Environment and Config File Support**: Multiple ways to configure the core provider

## Implementation Details

### New Configuration Options

#### Environment Variable

```bash
export CODEX_CORE_PROVIDER=gemini
```

#### Config File (YAML)

```yaml
coreProvider: "gemini"
```

#### Config File (JSON)

```json
{
  "coreProvider": "gemini"
}
```

### Provider Default Models

Each provider now has sensible defaults instead of OpenAI models:

| Provider   | Agentic Model               | Full Context Model          |
| ---------- | --------------------------- | --------------------------- |
| openai     | codex-mini-latest           | gpt-4.1                     |
| gemini     | gemini-1.5-flash            | gemini-1.5-pro              |
| ollama     | llama3.2:latest             | llama3.2:latest             |
| deepseek   | deepseek-chat               | deepseek-reasoner           |
| mistral    | mistral-small-latest        | mistral-large-latest        |
| groq       | llama-3.3-70b-versatile     | llama-3.3-70b-versatile     |
| xai        | grok-beta                   | grok-beta                   |
| openrouter | anthropic/claude-3.5-sonnet | anthropic/claude-3.5-sonnet |
| arceeai    | arcee-agent                 | arcee-agent                 |

### API Key Behavior Changes

#### New Function: `getApiKey(provider, fallbackToOpenAI = false)`

- By default, does NOT fall back to `OPENAI_API_KEY`
- Only uses provider-specific API keys
- Maintains backward compatibility with explicit fallback flag

#### Legacy Function: `getApiKeyWithFallback(provider)`

- Maintains old behavior of falling back to `OPENAI_API_KEY`
- Used for backward compatibility where needed

### Code Changes

#### Files Modified

1. **`src/utils/config.ts`**
   - Added `DEFAULT_CORE_PROVIDER` constant
   - Added `PROVIDER_DEFAULT_MODELS` mapping
   - Modified `getApiKey()` to remove automatic OpenAI fallback
   - Added `getApiKeyWithFallback()` for legacy behavior
   - Added `getCoreProvider()` and `getProviderDefaultModel()` functions
   - Updated `StoredConfig` and `AppConfig` types to include `coreProvider`
   - Modified `loadConfig()` to use provider-specific default models
   - Updated `saveConfig()` to persist core provider setting

#### New Functions

```typescript
// Get the configured core provider
getCoreProvider(): string

// Get default model for a provider
getProviderDefaultModel(provider: string, isFullContext: boolean): string

// Get API key without OpenAI fallback (new default behavior)
getApiKey(provider: string, fallbackToOpenAI: boolean = false): string | undefined

// Legacy function with OpenAI fallback
getApiKeyWithFallback(provider: string): string | undefined
```

## Usage Examples

### Setting Core Provider to Gemini

**Method 1: Environment Variable**

```bash
export CODEX_CORE_PROVIDER=gemini
export GEMINI_API_KEY=your_api_key_here
codex "help me debug this function"
```

**Method 2: Configuration File**

```yaml
# ~/.codex/config.yaml
coreProvider: "gemini"
```

**Method 3: Per-Session Override**

```bash
codex --provider gemini "help me debug this function"
```

### Setting Core Provider to Ollama (Local)

```bash
export CODEX_CORE_PROVIDER=ollama
# No API key needed for Ollama
codex "help me refactor this code"
```

### Setting Core Provider to DeepSeek

```yaml
# ~/.codex/config.yaml
coreProvider: "deepseek"
```

```bash
export DEEPSEEK_API_KEY=your_api_key_here
codex "explain this algorithm"
```

## Migration Guide

### For Existing Users

**No breaking changes** - existing configurations continue to work:

- Default core provider remains `"openai"`
- OpenAI API key fallback behavior preserved where expected
- All existing provider configurations remain functional

### For New Users

**Recommended setup for non-OpenAI providers:**

1. Set your preferred core provider:

   ```bash
   echo 'coreProvider: "gemini"' >> ~/.codex/config.yaml
   ```

2. Set the appropriate API key:

   ```bash
   export GEMINI_API_KEY=your_api_key_here
   ```

3. Now Codex will use Gemini by default without requiring OpenAI credentials

## Benefits

1. **Provider Independence**: No longer requires OpenAI API key when using other providers
2. **Appropriate Defaults**: Each provider gets sensible default models instead of OpenAI models
3. **Flexible Configuration**: Multiple ways to set core provider (env var, config file, CLI flag)
4. **Backward Compatibility**: Existing configurations continue to work unchanged
5. **Clear API Key Behavior**: Explicit choice between fallback and non-fallback behavior

## Testing

The implementation includes:

- TypeScript type checking (passes)
- Existing configuration tests (pass)
- Backward compatibility with existing API key resolution
- Provider-specific model resolution

## Future Enhancements

Potential future improvements:

- Provider-specific configuration validation
- Dynamic model list fetching per provider
- Provider capability detection (e.g., which supports function calling)
- Provider cost estimation and optimization recommendations
