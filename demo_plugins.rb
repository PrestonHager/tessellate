#!/usr/bin/env ruby
# frozen_string_literal: true

# Demo script showing Tessellate plugins in action
# This script demonstrates the functionality of each plugin with sample content

puts "Tessellate Jekyll Theme - Plugin Demonstration"
puts "=" * 55

# Load plugins without Liquid registration for demo
# Include the module code directly to avoid Liquid dependencies

module Jekyll
  module MarkdownSplit
    def markdown_split(content)
      content.split(/^\s*[-*_]{3,}\s*$/m)
    end
  end
  
  module ParagraphSplit
    def paragraph_split(markdown, n)
      blocks = []
      current_block = []
      in_code_block = false

      # Split the markdown into blocks
      markdown.each_line do |line|
        line.chomp!
        if line.start_with?('```')
          if in_code_block
            current_block << line
            blocks << current_block.join("\n")
            current_block = []
            in_code_block = false
          else
            if current_block.any?
              blocks << current_block.join("\n")
              current_block = []
            end
            current_block << line
            in_code_block = true
          end
        elsif in_code_block
          current_block << line
        else
          if line.strip.empty?
            if current_block.any?
              blocks << current_block.join("\n")
              current_block = []
            end
          elsif line.match(/^(\* |\- |\d+\. )/)
            if current_block.any?
              blocks << current_block.join("\n")
              current_block = []
            end
            blocks << line
          elsif line.start_with?(/#+/)
            if current_block.any?
              blocks << current_block.join("\n")
              current_block = []
            end
            blocks << line
          elsif line.strip == '---'
            if current_block.any?
              blocks << current_block.join("\n")
              current_block = []
            end
            blocks << line
          else
            current_block << line
          end
        end
      end

      if current_block.any?
        blocks << current_block.join("\n")
      end

      # Check for horizontal rules
      hr_indices = blocks.each_index.select { |i| blocks[i].strip == '---' }
      hr_count = hr_indices.size

      # Case 1: Exactly n-1 horizontal rules
      if hr_count == n - 1
        groups = []
        previous = 0
        hr_indices.each do |i|
          groups << blocks[previous...i]
          previous = i + 1
        end
        groups << blocks[previous..-1]

        columns = groups.map { |g| g.join("\n\n") }
        columns.fill('', columns.size...n) if columns.size < n
        columns[0...n]
      else
        # Case 2 and 3: Handle other scenarios
        if hr_count > 0 && hr_count < n - 1
          # Split into groups at horizontal rules
          groups = []
          previous = 0
          hr_indices.each do |i|
            groups << blocks[previous...i]
            previous = i + 1
          end
          groups << blocks[previous..-1]

          k = groups.size
          base_cols = n / k
          remainder = n % k
          columns = []

          groups.each_with_index do |group, idx|
            cols_for_group = idx < remainder ? base_cols + 1 : base_cols

            group_columns = Array.new(cols_for_group) { [] }
            total_group_blocks = group.size

            cols_for_group.times do |j|
              start_idx = (j * total_group_blocks) / cols_for_group
              end_idx = ((j + 1) * total_group_blocks) / cols_for_group - 1
              end_idx = [end_idx, total_group_blocks - 1].min

              if start_idx <= end_idx
                group_columns[j] = group[start_idx..end_idx]
              else
                group_columns[j] = []
              end
            end

            columns += group_columns.map { |c| c.join("\n\n") }
          end

          columns
        else
          # Original block distribution
          columns = Array.new(n) { [] }
          total_blocks = blocks.size

          n.times do |i|
            start_idx = (i * total_blocks) / n
            end_idx = ((i + 1) * total_blocks) / n - 1
            end_idx = [end_idx, total_blocks - 1].min

            if start_idx <= end_idx
              columns[i] = blocks[start_idx..end_idx]
            else
              columns[i] = []
            end
          end

          columns.map { |col| col.join("\n\n") }
        end
      end
    end
  end
end

# Create test class with all filters
class PluginDemo
  include Jekyll::MarkdownSplit
  include Jekyll::ParagraphSplit
end

demo = PluginDemo.new

puts "\n1. MarkdownSplit Plugin Demo:"
puts "-" * 30

sample_content = <<~MARKDOWN
  # Introduction
  
  This is the first section of our content.
  
  ---
  
  # Main Content
  
  This is the main section with important information.
  
  ***
  
  # Conclusion
  
  This is the final section wrapping everything up.
MARKDOWN

puts "Input content:"
puts sample_content
puts "\nSplit result:"
result = demo.markdown_split(sample_content)
result.each_with_index do |section, index|
  puts "\n--- Section #{index + 1} ---"
  puts section
end

puts "\n" + "=" * 55

puts "\n2. ParagraphSplit Plugin Demo:"
puts "-" * 35

sample_markdown = <<~MARKDOWN
  # Welcome to Our Site
  
  This is the introduction paragraph that explains what we're about.
  
  ## Our Mission
  
  We strive to create amazing experiences for our users through thoughtful design.
  
  ## Our Values
  
  * Quality
  * Innovation  
  * Customer focus
  
  ## Contact Information
  
  You can reach us through multiple channels for support and inquiries.
  
  We're here to help you succeed with our products and services.
MARKDOWN

puts "Input markdown:"
puts sample_markdown

puts "\nSplit into 2 columns:"
columns = demo.paragraph_split(sample_markdown, 2)
columns.each_with_index do |column, index|
  puts "\n--- Column #{index + 1} ---"
  puts column
  puts "(" + "~" * 40 + ")"
end

puts "\nSplit into 3 columns:"
columns = demo.paragraph_split(sample_markdown, 3)
columns.each_with_index do |column, index|
  puts "\n--- Column #{index + 1} ---"
  puts column
  puts "(" + "~" * 25 + ")"
end

puts "\n" + "=" * 55
puts "\n3. SubviewTag Plugin (Structure Demo):"
puts "-" * 45

puts "\nThe SubviewTag plugin allows embedding one Jekyll page within another."
puts "It searches for pages by:"
puts "  - Full path: '/path/to/document.md'"
puts "  - Relative path: 'relative/document.md'"  
puts "  - Basename: 'document.md'"
puts "\nUsage in Liquid templates:"
puts "  {% subview 'path/to/page.md' %}"
puts "\nThis enables modular content composition in Jekyll sites."

puts "\n" + "=" * 55
puts "\nDemo completed! These plugins enhance Jekyll with:"
puts "  ✓ Content splitting for multi-column layouts"
puts "  ✓ Flexible markdown organization"
puts "  ✓ Reusable content components"
puts "\nFor more details, see the test suite: ruby test_suite.rb"