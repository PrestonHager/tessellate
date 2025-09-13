# Tessellate Testing

This directory contains comprehensive tests for the Tessellate Jekyll theme.

## Test Structure

### RSpec Tests (spec/)
Professional test suite using RSpec framework:
- `spec/plugins/` - Unit tests for each plugin
- `spec/integration/` - Integration tests for theme functionality
- `spec/spec_helper.rb` - Test configuration

### Standalone Tests (test_suite.rb)
Dependency-free test runner that works without Jekyll/RSpec installation:
- Tests core plugin logic
- Validates theme structure
- Checks configuration files

## Running Tests

### With RSpec (recommended for development)
```bash
# Install dependencies
bundle install

# Run all tests
bundle exec rake spec

# Run specific test types
bundle exec rake spec:plugins
bundle exec rake spec:integration
```

### Standalone (works anywhere with Ruby)
```bash
# No dependencies required
ruby test_suite.rb
```

### CI/CD
GitHub Actions automatically runs tests on:
- All push/PR to main and develop branches
- Multiple Ruby versions (3.0, 3.1, 3.2, 3.3)
- Includes Jekyll build verification

## Test Coverage

### Plugin Tests
1. **MarkdownSplit Plugin** - Tests horizontal rule content splitting
2. **ParagraphSplit Plugin** - Tests complex markdown column distribution  
3. **SubviewTag Plugin** - Tests Liquid tag functionality

### Integration Tests
- Theme configuration validation
- File structure verification
- Gemspec compliance
- Jekyll compatibility

## Test Results
All tests currently pass ✅ (27/27 successful)

## Adding New Tests

### For Plugins
Add to `spec/plugins/[plugin_name]_spec.rb`:
```ruby
RSpec.describe Jekyll::YourPlugin do
  # Test implementation
end
```

### For Theme Features
Add to `spec/integration/theme_spec.rb` or create new integration test files.

### For Standalone Tests
Add test cases to `test_suite.rb` in the `run_tests` function.