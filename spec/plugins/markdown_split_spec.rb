# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../_plugins/markdown_split'

RSpec.describe Jekyll::MarkdownSplit do
  let(:test_class) do
    Class.new do
      include Jekyll::MarkdownSplit
    end
  end
  let(:instance) { test_class.new }

  describe '#markdown_split' do
    context 'with simple content' do
      it 'splits on horizontal rules with dashes' do
        content = "First section\n---\nSecond section"
        result = instance.markdown_split(content)
        
        expect(result).to eq(["First section\n", "\nSecond section"])
      end

      it 'splits on horizontal rules with asterisks' do
        content = "First section\n***\nSecond section"
        result = instance.markdown_split(content)
        
        expect(result).to eq(["First section\n", "\nSecond section"])
      end

      it 'splits on horizontal rules with underscores' do
        content = "First section\n___\nSecond section"
        result = instance.markdown_split(content)
        
        expect(result).to eq(["First section\n", "\nSecond section"])
      end
    end

    context 'with multiple sections' do
      it 'splits into multiple parts' do
        content = "Section 1\n---\nSection 2\n***\nSection 3\n___\nSection 4"
        result = instance.markdown_split(content)
        
        expect(result).to eq(["Section 1\n", "\nSection 2\n", "\nSection 3\n", "\nSection 4"])
      end
    end

    context 'with whitespace variations' do
      it 'handles horizontal rules with leading whitespace' do
        content = "First section\n  ---  \nSecond section"
        result = instance.markdown_split(content)
        
        expect(result).to eq(["First section\n", "\nSecond section"])
      end

      it 'handles horizontal rules with extra characters' do
        content = "First section\n-----\nSecond section"
        result = instance.markdown_split(content)
        
        expect(result).to eq(["First section\n", "\nSecond section"])
      end
    end

    context 'with no horizontal rules' do
      it 'returns the original content as single element' do
        content = "Just one section with no splits"
        result = instance.markdown_split(content)
        
        expect(result).to eq(["Just one section with no splits"])
      end
    end

    context 'with empty content' do
      it 'handles empty string' do
        content = ""
        result = instance.markdown_split(content)
        
        expect(result).to eq([])  # Empty string split returns empty array
      end
    end

    context 'with edge cases' do
      it 'handles content starting with horizontal rule' do
        content = "---\nFirst section\n---\nSecond section"
        result = instance.markdown_split(content)
        
        expect(result).to eq(["", "\nFirst section\n", "\nSecond section"])
      end

      it 'handles content ending with horizontal rule' do
        content = "First section\n---\nSecond section\n---"
        result = instance.markdown_split(content)
        
        expect(result).to eq(["First section\n", "\nSecond section\n", ""])
      end
    end
  end
end