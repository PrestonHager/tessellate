#!/usr/bin/env ruby
# CI Test Runner - Simulates GitHub Actions CI workflow locally
# This is equivalent to running the CI tasks in the GitHub Actions environment

puts "=" * 60
puts "CI Test Runner - Simulating GitHub Actions Workflow"
puts "=" * 60

# Test 1: Basic Test Suite (equivalent to the adhoc environment)
puts "\n1. Running Basic Test Suite..."
puts "-" * 40

test_result = system("ruby test_suite.rb")
if test_result
  puts "✓ Basic test suite: PASSED"
else
  puts "✗ Basic test suite: FAILED"
  exit 1
end

# Test 2: Jekyll Build Test
puts "\n2. Testing Jekyll Build..."
puts "-" * 40

# Set up environment
ENV['PATH'] = "/home/runner/.local/share/gem/ruby/3.2.0/bin:#{ENV['PATH']}"
ENV['JEKYLL_NO_BUNDLER_REQUIRE'] = '1'
ENV['JEKYLL_ENV'] = 'test'

build_result = system("jekyll build --trace")
if build_result
  puts "✓ Jekyll build: PASSED"
else
  puts "✗ Jekyll build: FAILED"
  exit 1
end

# Test 3: Jekyll Serve Test (dry run)
puts "\n3. Testing Jekyll Serve (dry run)..."
puts "-" * 40

serve_success = false
begin
  # Start Jekyll server in background
  pid = spawn("jekyll serve --detach --port 4001 2>/dev/null")
  sleep 3
  
  # Check if server is running
  if system("pgrep -f 'jekyll serve' > /dev/null")
    puts "✓ Jekyll server started successfully"
    serve_success = true
    # Clean up server
    system("pkill -f 'jekyll serve'")
  else
    puts "✗ Jekyll server failed to start"
  end
rescue => e
  puts "✗ Jekyll serve test failed: #{e.message}"
end

exit 1 unless serve_success

# Test 4: Plugin File Validation
puts "\n4. Validating Plugin Files..."
puts "-" * 40

plugins = [
  '_plugins/markdown_split.rb',
  '_plugins/paragraph_split.rb',
  '_plugins/subview.rb'
]

plugins.each do |plugin|
  if File.exist?(plugin)
    # Test if plugin loads without errors
    begin
      # Use a temporary test to load the plugin
      temp_file = "/tmp/test_plugin_#{File.basename(plugin, '.rb')}.rb"
      File.write(temp_file, <<~RUBY)
        require 'jekyll'
        require 'liquid'
        load '#{File.expand_path(plugin)}'
      RUBY
      
      result = system("ruby #{temp_file} 2>/dev/null")
      File.delete(temp_file) if File.exist?(temp_file)
      
      if result
        puts "✓ #{plugin}: VALID"
      else
        puts "✗ #{plugin}: ERROR - failed to load"
        exit 1
      end
    rescue => e
      puts "✗ #{plugin}: ERROR - #{e.message}"
      exit 1
    end
  else
    puts "✗ #{plugin}: MISSING"
    exit 1
  end
end

# Test 5: Gem Build Test
puts "\n5. Testing Gem Build..."
puts "-" * 40

# Clean up any existing gem files
system("rm -f *.gem")

build_gem_result = system("gem build tessellate.gemspec 2>/dev/null")
if build_gem_result && Dir.glob("*.gem").any?
  puts "✓ Gem build: PASSED"
  # Clean up
  system("rm -f *.gem")
else
  puts "✗ Gem build: FAILED"
  exit 1
end

# Test 6: Ruby Version Compatibility Test
puts "\n6. Testing Ruby Version Compatibility..."
puts "-" * 40

ruby_version = RUBY_VERSION
puts "✓ Running on Ruby #{ruby_version}"

if Gem::Version.new(ruby_version) >= Gem::Version.new('3.0.0')
  puts "✓ Ruby version compatibility: PASSED"
else
  puts "✗ Ruby version compatibility: FAILED (needs Ruby 3.0+)"
  exit 1
end

# Summary
puts "\n" + "=" * 60
puts "CI Test Results Summary"
puts "=" * 60
puts "✓ All CI tests PASSED"
puts "✓ Theme is ready for deployment"
puts "✓ Jekyll build works correctly"
puts "✓ All plugins load without errors"
puts "✓ Gem builds successfully"
puts "=" * 60

puts "\nCI Test Runner completed successfully!"
puts "This simulates the GitHub Actions workflow and confirms all tests pass."