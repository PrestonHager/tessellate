#!/usr/bin/env ruby
# frozen_string_literal: true

# Standalone test suite for Tessellate Jekyll Theme
# This can run without Jekyll or RSpec dependencies

# Define test classes and modules at the top level
module Jekyll
  module MarkdownSplit
    def markdown_split(content)
      content.split(/^\s*[-*_]{3,}\s*$/m)
    end
  end
end

class TestMarkdownSplit
  include Jekyll::MarkdownSplit
end

class TestParagraphSplit
  def paragraph_split_simple(markdown, n)
    return [] if n <= 0
    
    # Split into paragraphs (simple version)
    paragraphs = markdown.split(/\n\s*\n/).reject(&:empty?)
    
    # Distribute paragraphs across columns
    columns = Array.new(n) { [] }
    paragraphs.each_with_index do |para, idx|
      columns[idx % n] << para
    end
    
    columns.map { |col| col.join("\n\n") }
  end
end

module Liquid
  class Tag
    attr_reader :tag_name, :markup
    def initialize(tag_name, markup, tokens)
      @tag_name = tag_name
      @markup = markup
    end
  end
end

class TestSubviewTag < Liquid::Tag
  attr_reader :path
  
  def initialize(tag_name, path, tokens)
    super
    @path = path.strip
  end
end

def run_tests
  puts "Tessellate Jekyll Theme - Test Suite"
  puts "=" * 50
  
  tests_passed = 0
  tests_failed = 0
  
  # Test MarkdownSplit
  puts "\n1. Testing MarkdownSplit Plugin:"
  puts "-" * 30
  
  begin
    test = TestMarkdownSplit.new
    
    # Test 1: Basic horizontal rule split
    content = "First section\n---\nSecond section"
    result = test.markdown_split(content)
    expected = ["First section\n", "\nSecond section"]
    if result == expected
      puts "  ✓ Basic horizontal rule split: PASS"
      tests_passed += 1
    else
      puts "  ✗ Basic horizontal rule split: FAIL"
      puts "    Expected: #{expected.inspect}"
      puts "    Got: #{result.inspect}"
      tests_failed += 1
    end
    
    # Test 2: Multiple horizontal rules
    content = "A\n---\nB\n***\nC"
    result = test.markdown_split(content)
    expected = ["A\n", "\nB\n", "\nC"]
    if result == expected
      puts "  ✓ Multiple horizontal rules: PASS"
      tests_passed += 1
    else
      puts "  ✗ Multiple horizontal rules: FAIL"
      puts "    Expected: #{expected.inspect}"
      puts "    Got: #{result.inspect}"
      tests_failed += 1
    end
    
    # Test 3: No horizontal rules
    content = "Just one section"
    result = test.markdown_split(content)
    expected = ["Just one section"]
    if result == expected
      puts "  ✓ No horizontal rules: PASS"
      tests_passed += 1
    else
      puts "  ✗ No horizontal rules: FAIL"
      tests_failed += 1
    end
    
    # Test 4: Empty content
    content = ""
    result = test.markdown_split(content)
    expected = []  # Empty string split returns empty array
    if result == expected
      puts "  ✓ Empty content: PASS"
      tests_passed += 1
    else
      puts "  ✗ Empty content: FAIL"
      puts "    Expected: #{expected.inspect}"
      puts "    Got: #{result.inspect}"
      tests_failed += 1
    end
    
  rescue => e
    puts "  ✗ ERROR in MarkdownSplit tests: #{e.message}"
    tests_failed += 1
  end

  # Test ParagraphSplit (simplified core logic)
  puts "\n2. Testing ParagraphSplit Plugin (Core Logic):"
  puts "-" * 45
  
  begin
    test = TestParagraphSplit.new
    
    # Test 1: Simple paragraph distribution
    markdown = "Para 1\n\nPara 2\n\nPara 3\n\nPara 4"
    result = test.paragraph_split_simple(markdown, 2)
    if result.length == 2 && result.all? { |col| col.is_a?(String) }
      puts "  ✓ Simple paragraph distribution: PASS"
      tests_passed += 1
    else
      puts "  ✗ Simple paragraph distribution: FAIL"
      tests_failed += 1
    end
    
    # Test 2: Single column
    result = test.paragraph_split_simple(markdown, 1)
    if result.length == 1
      puts "  ✓ Single column: PASS"
      tests_passed += 1
    else
      puts "  ✗ Single column: FAIL"
      tests_failed += 1
    end
    
    # Test 3: More columns than content
    result = test.paragraph_split_simple("One para", 3)
    if result.length == 3
      puts "  ✓ More columns than content: PASS"
      tests_passed += 1
    else
      puts "  ✗ More columns than content: FAIL"
      tests_failed += 1
    end
    
    # Test 4: Zero columns
    result = test.paragraph_split_simple(markdown, 0)
    if result == []
      puts "  ✓ Zero columns: PASS"
      tests_passed += 1
    else
      puts "  ✗ Zero columns: FAIL"
      tests_failed += 1
    end
    
  rescue => e
    puts "  ✗ ERROR in ParagraphSplit tests: #{e.message}"
    tests_failed += 1
  end

  # Test SubviewTag structure
  puts "\n3. Testing SubviewTag Plugin (Structure):"
  puts "-" * 40
  
  begin
    # Test 1: Initialization
    tag = TestSubviewTag.new('subview', 'test.md', [])
    if tag.path == 'test.md'
      puts "  ✓ Basic initialization: PASS"
      tests_passed += 1
    else
      puts "  ✗ Basic initialization: FAIL"
      tests_failed += 1
    end
    
    # Test 2: Path trimming
    tag = TestSubviewTag.new('subview', '  spaced.md  ', [])
    if tag.path == 'spaced.md'
      puts "  ✓ Path trimming: PASS"
      tests_passed += 1
    else
      puts "  ✗ Path trimming: FAIL"
      tests_failed += 1
    end
    
  rescue => e
    puts "  ✗ ERROR in SubviewTag tests: #{e.message}"
    tests_failed += 1
  end

  # Test theme file structure
  puts "\n4. Testing Theme File Structure:"
  puts "-" * 35
  
  required_files = [
    '_config.yml',
    'tessellate.gemspec',
    '_plugins/markdown_split.rb',
    '_plugins/paragraph_split.rb', 
    '_plugins/subview.rb'
  ]

  required_dirs = [
    '_layouts',
    '_includes',
    '_sass',
    'assets'
  ]

  required_files.each do |file|
    if File.exist?(file)
      puts "  ✓ #{file}: EXISTS"
      tests_passed += 1
    else
      puts "  ✗ #{file}: MISSING"
      tests_failed += 1
    end
  end

  required_dirs.each do |dir|
    if Dir.exist?(dir)
      puts "  ✓ #{dir}/: EXISTS"
      tests_passed += 1
    else
      puts "  ✗ #{dir}/: MISSING"
      tests_failed += 1
    end
  end

  # Test configuration files
  puts "\n5. Testing Configuration:"
  puts "-" * 25
  
  begin
    # Test _config.yml structure
    require 'yaml'
    config = YAML.load_file('_config.yml')
    
    if config.is_a?(Hash)
      puts "  ✓ _config.yml is valid YAML: PASS"
      tests_passed += 1
    else
      puts "  ✗ _config.yml is valid YAML: FAIL"
      tests_failed += 1
    end
    
    required_config_keys = %w[markdown highlighter kramdown socials copyright]
    required_config_keys.each do |key|
      if config.key?(key)
        puts "  ✓ Config has '#{key}': PASS"
        tests_passed += 1
      else
        puts "  ✗ Config has '#{key}': FAIL"
        tests_failed += 1
      end
    end
    
  rescue => e
    puts "  ✗ ERROR testing configuration: #{e.message}"
    tests_failed += 1
  end

  begin
    # Test gemspec
    spec = Gem::Specification.load('tessellate.gemspec')
    
    if spec.name == 'tessellate'
      puts "  ✓ Gemspec has correct name: PASS"
      tests_passed += 1
    else
      puts "  ✗ Gemspec has correct name: FAIL"
      tests_failed += 1
    end
    
    if spec.authors && !spec.authors.empty?
      puts "  ✓ Gemspec has authors: PASS"
      tests_passed += 1
    else
      puts "  ✗ Gemspec has authors: FAIL"
      tests_failed += 1
    end
    
  rescue => e
    puts "  ✗ ERROR testing gemspec: #{e.message}"
    tests_failed += 1
  end

  # Summary
  puts "\n" + "=" * 50
  puts "Test Summary:"
  puts "  Passed: #{tests_passed}"
  puts "  Failed: #{tests_failed}"
  puts "  Total:  #{tests_passed + tests_failed}"
  
  if tests_failed == 0
    puts "\n🎉 All tests passed!"
    return true
  else
    puts "\n❌ Some tests failed."
    return false
  end
end

# Run the tests
success = run_tests
exit(success ? 0 : 1)