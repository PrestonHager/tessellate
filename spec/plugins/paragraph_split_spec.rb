# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../_plugins/paragraph_split'

RSpec.describe Jekyll::ParagraphSplit do
  let(:test_class) do
    Class.new do
      include Jekyll::ParagraphSplit
    end
  end
  let(:instance) { test_class.new }

  describe '#paragraph_split' do
    context 'with simple markdown content' do
      it 'splits simple paragraphs into columns' do
        markdown = "First paragraph\n\nSecond paragraph\n\nThird paragraph\n\nFourth paragraph"
        result = instance.paragraph_split(markdown, 2)
        
        expect(result).to be_an(Array)
        expect(result.length).to eq(2)
        expect(result[0]).to include("First paragraph")
        expect(result[1]).to include("Third paragraph")
      end

      it 'handles single column' do
        markdown = "First paragraph\n\nSecond paragraph"
        result = instance.paragraph_split(markdown, 1)
        
        expect(result.length).to eq(1)
        expect(result[0]).to include("First paragraph")
        expect(result[0]).to include("Second paragraph")
      end
    end

    context 'with horizontal rules' do
      it 'splits content with exactly n-1 horizontal rules' do
        markdown = "Column 1 content\n\n---\n\nColumn 2 content\n\n---\n\nColumn 3 content"
        result = instance.paragraph_split(markdown, 3)
        
        expect(result.length).to eq(3)
        expect(result[0]).to include("Column 1 content")
        expect(result[1]).to include("Column 2 content")
        expect(result[2]).to include("Column 3 content")
      end

      it 'handles fewer horizontal rules than columns' do
        markdown = "Group 1\n\n---\n\nGroup 2\n\nMore content"
        result = instance.paragraph_split(markdown, 4)
        
        expect(result.length).to eq(4)
        expect(result).to all(be_a(String))
      end
    end

    context 'with code blocks' do
      it 'preserves code blocks' do
        markdown = "Text before\n\n```ruby\ndef hello\n  puts 'world'\nend\n```\n\nText after"
        result = instance.paragraph_split(markdown, 2)
        
        expect(result.join).to include("```ruby")
        expect(result.join).to include("def hello")
        expect(result.join).to include("```")
      end
    end

    context 'with headers' do
      it 'handles headers as separate blocks' do
        markdown = "# Header 1\n\nParagraph 1\n\n## Header 2\n\nParagraph 2"
        result = instance.paragraph_split(markdown, 2)
        
        expect(result).to be_an(Array)
        expect(result.length).to eq(2)
        expect(result.join).to include("# Header 1")
        expect(result.join).to include("## Header 2")
      end
    end

    context 'with lists' do
      it 'handles list items as separate blocks' do
        markdown = "* Item 1\n* Item 2\n- Item 3\n1. Numbered item"
        result = instance.paragraph_split(markdown, 2)
        
        expect(result).to be_an(Array)
        expect(result.length).to eq(2)
        expect(result.join).to include("* Item 1")
        expect(result.join).to include("1. Numbered item")
      end
    end

    context 'with edge cases' do
      it 'handles empty content' do
        result = instance.paragraph_split("", 2)
        
        expect(result.length).to eq(2)
        expect(result).to all(eq(""))
      end

      it 'handles zero columns' do
        markdown = "Some content"
        result = instance.paragraph_split(markdown, 0)
        
        expect(result).to eq([])
      end

      it 'handles more columns than content blocks' do
        markdown = "Single paragraph"
        result = instance.paragraph_split(markdown, 5)
        
        expect(result.length).to eq(5)
        expect(result[0]).to eq("Single paragraph")
        expect(result[1..4]).to all(eq(""))
      end
    end

    context 'with mixed content types' do
      it 'handles complex markdown with multiple elements' do
        markdown = <<~MARKDOWN
          # Main Header
          
          First paragraph with some text.
          
          ## Sub Header
          
          * List item 1
          * List item 2
          
          ```javascript
          console.log('code block');
          ```
          
          Final paragraph.
        MARKDOWN
        
        result = instance.paragraph_split(markdown, 3)
        
        expect(result.length).to eq(3)
        expect(result).to all(be_a(String))
        expect(result.join).to include("# Main Header")
        expect(result.join).to include("console.log")
      end
    end
  end
end