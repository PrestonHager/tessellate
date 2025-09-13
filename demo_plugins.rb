#!/usr/bin/env ruby
# frozen_string_literal: true

# Demo script showing Tessellate plugins in action
# This script demonstrates the functionality of each plugin with sample content

puts "Tessellate Jekyll Theme - Plugin Demonstration"
puts "=" * 55

# Load plugins by requiring the files and ignoring Liquid registration errors
# This avoids code duplication while still allowing demos to work

# Temporarily suppress Liquid registration errors
module Liquid
  class Template
    def self.register_filter(mod)
      # Ignore registration for demo purposes
    end
    
    def self.register_tag(name, klass)
      # Ignore registration for demo purposes  
    end
  end
  
  class Tag
    def initialize(tag_name, markup, tokens)
      @tag_name = tag_name
      @markup = markup
    end
  end
end

# Now load the actual plugin files
require_relative '_plugins/markdown_split'
require_relative '_plugins/paragraph_split'
require_relative '_plugins/subview'

# Demo classes that include the actual plugin modules
class DemoMarkdownSplit
  include Jekyll::MarkdownSplit
end

class DemoParagraphSplit  
  include Jekyll::ParagraphSplit
end

class DemoSubviewTag < Jekyll::SubviewTag
  attr_reader :path
  
  def initialize(path)
    # Initialize without Liquid dependencies
    @path = path.strip
  end
end

puts "\n=== 1. MarkdownSplit Plugin Demo ==="
puts "-" * 40

demo_split = DemoMarkdownSplit.new

sample_content = <<~MARKDOWN
  # Introduction

  This is the first section of our content. It contains some introductory 
  material that sets the stage for what's to come.

  ---

  ## Main Content

  Here's the main body of our document. This section contains the core
  information that we want to convey to our readers.

  It might span multiple paragraphs and include various formatting elements.

  ***

  ### Conclusion

  Finally, we wrap up with some concluding thoughts and perhaps a call
  to action for our readers.
MARKDOWN

puts "Original content:"
puts sample_content
puts "\nAfter markdown_split:"
result = demo_split.markdown_split(sample_content)
result.each_with_index do |section, i|
  puts "\n--- Section #{i + 1} ---"
  puts section
end

puts "\n=== 2. ParagraphSplit Plugin Demo ==="
puts "-" * 40

demo_para = DemoParagraphSplit.new

complex_content = <<~MARKDOWN
  # Advanced Usage Guide

  ## Getting Started

  First, you'll need to understand the basics of how this system works.

  ### Installation

  1. Download the package
  2. Extract to your desired location
  3. Run the setup script

  ## Configuration

  The configuration file allows you to customize various aspects:

  ```yaml
  settings:
    theme: dark
    language: en
  ```

  Make sure to backup your configuration before making changes.

  ---

  ## Advanced Features

  ### Custom Scripts

  You can write custom scripts to extend functionality:

  ```javascript
  function customHandler() {
    return "Hello World";
  }
  ```

  ### API Integration

  * Connect to external services
  * Handle authentication
  * Process responses

  Remember to follow security best practices.

  ## Troubleshooting

  If you encounter issues:

  1. Check the logs
  2. Verify your configuration
  3. Contact support if needed
MARKDOWN

puts "Original content:"
puts complex_content
puts "\n" + "=" * 60

# Demo with 2 columns
puts "\nSplit into 2 columns:"
columns_2 = demo_para.paragraph_split(complex_content, 2)
columns_2.each_with_index do |column, i|
  puts "\n--- Column #{i + 1} ---"
  puts column
  puts "-" * 20
end

# Demo with 3 columns  
puts "\nSplit into 3 columns:"
columns_3 = demo_para.paragraph_split(complex_content, 3)
columns_3.each_with_index do |column, i|
  puts "\n--- Column #{i + 1} ---"
  puts column
  puts "-" * 20
end

puts "\n=== 3. SubviewTag Plugin Demo ==="
puts "-" * 40

demo_tag1 = DemoSubviewTag.new('about.md')
demo_tag2 = DemoSubviewTag.new('  contact.html  ')
demo_tag3 = DemoSubviewTag.new('nested/deep/file.md')

puts "Tag path handling examples:"
puts "Input: 'about.md' -> Path: '#{demo_tag1.path}'"
puts "Input: '  contact.html  ' -> Path: '#{demo_tag2.path}'"
puts "Input: 'nested/deep/file.md' -> Path: '#{demo_tag3.path}'"

puts "\nNote: In a real Jekyll environment, these tags would:"
puts "• Find and render the specified pages"
puts "• Handle missing files gracefully"  
puts "• Support full path, relative path, and basename matching"

puts "\n=== Demo Complete ==="
puts "\nThese examples show how each plugin processes content:"
puts "• MarkdownSplit: Divides content at horizontal rules"
puts "• ParagraphSplit: Intelligently distributes content across columns"
puts "• SubviewTag: Includes other pages within the current page"
puts "\nFor complete functionality, use these plugins in a Jekyll site environment."