# frozen_string_literal: true

require_relative '../spec_helper'

# We need to set up mock classes before requiring the plugin
# Mock Liquid and Jekyll classes for testing
module Liquid
  class Tag
    attr_reader :tag_name, :markup
    
    def initialize(tag_name, markup, tokens)
      @tag_name = tag_name
      @markup = markup
    end
    
    # Ensure new is public method
    public_class_method :new if private_methods.include?(:new)
  end
  
  # Don't redefine Template - use the existing one and just mock register_tag
  class << Template
    alias_method :original_register_tag, :register_tag if method_defined?(:register_tag)
    
    def register_tag(name, klass)
      # Mock registration for tests
    end
  end
end

module Jekyll
  # Mock the logger
  class << self
    def logger
      @logger ||= MockLogger.new
    end
  end
  
  class MockLogger
    def error(*args); end
    def debug(*args); end
    def info(*args); end
  end
  
  class Document
    attr_accessor :path, :relative_path, :output
    
    def initialize(path)
      @path = path
      @relative_path = path
      @output = ""
    end
  end
  
  class Site
    attr_accessor :pages, :site_payload
    
    def initialize
      @pages = []
      @site_payload = {}
    end
  end
  
  class Renderer
    def initialize(site, document, payload)
      @site = site
      @document = document
      @payload = payload
    end
    
    def run
      "Rendered content for #{@document.path}"
    end
  end
  
  module Logger
    def self.error(tag, message)
      # Mock logger
    end
    
    def self.debug(tag, message)
      # Mock logger
    end
  end
end

require_relative '../../_plugins/subview'

RSpec.describe Jekyll::SubviewTag do
  let(:site) { Jekyll::Site.new }
  let(:context) do
    double('context', registers: {
      site: site,
      page: { 'path' => 'current_page.md' }
    })
  end

  describe '#initialize' do
    it 'strips whitespace from path' do
      tag = Jekyll::SubviewTag.new('subview', '  test_path.md  ', [])
      expect(tag.instance_variable_get(:@path)).to eq('test_path.md')
    end
  end

  describe '#render' do
    context 'when subview document exists' do
      before do
        page = Jekyll::Document.new('test_subview.md')
        page.relative_path = 'test_subview.md'
        site.pages << page
      end

      it 'renders the subview document' do
        tag = Jekyll::SubviewTag.new('subview', 'test_subview.md', [])
        result = tag.render(context)
        
        expect(result).to include('Rendered content for test_subview.md')
      end
    end

    context 'when subview document does not exist' do
      it 'returns empty string when document not found' do
        tag = Jekyll::SubviewTag.new('subview', 'nonexistent.md', [])
        result = tag.render(context)
        
        expect(result).to eq('')
      end
    end

    context 'with different path matching' do
      before do
        page1 = Jekyll::Document.new('/full/path/document.md')
        page1.relative_path = 'relative/document.md'
        
        page2 = Jekyll::Document.new('basename_only.md')
        page2.relative_path = 'some/path/basename_only.md'
        
        site.pages << page1
        site.pages << page2
      end

      it 'finds document by full path' do
        tag = Jekyll::SubviewTag.new('subview', '/full/path/document.md', [])
        result = tag.render(context)
        
        expect(result).to include('Rendered content for /full/path/document.md')
      end

      it 'finds document by relative path' do
        tag = Jekyll::SubviewTag.new('subview', 'relative/document.md', [])
        result = tag.render(context)
        
        expect(result).to include('Rendered content for /full/path/document.md')
      end

      it 'finds document by basename' do
        tag = Jekyll::SubviewTag.new('subview', 'basename_only.md', [])
        result = tag.render(context)
        
        expect(result).to include('Rendered content for basename_only.md')
      end
    end

    context 'when rendering fails' do
      before do
        page = Jekyll::Document.new('error_page.md')
        site.pages << page
        
        # Mock Jekyll::Renderer to raise an error
        allow(Jekyll::Renderer).to receive(:new).and_raise(StandardError.new('Rendering failed'))
      end

      it 'handles errors gracefully and returns empty string' do
        tag = Jekyll::SubviewTag.new('subview', 'error_page.md', [])
        result = tag.render(context)
        
        expect(result).to eq('')
      end
    end
  end

  describe 'private methods' do
    let(:tag) { Jekyll::SubviewTag.new('subview', 'test.md', []) }

    describe '#find_subview_document' do
      before do
        page = Jekyll::Document.new('test.md')
        site.pages << page
      end

      it 'finds the correct document' do
        document = tag.send(:find_subview_document, site)
        expect(document).to be_a(Jekyll::Document)
        expect(document.path).to eq('test.md')
      end
    end

    describe '#validate_subview' do
      it 'returns true when subview exists' do
        page = Jekyll::Document.new('test.md')
        result = tag.send(:validate_subview, page, site)
        expect(result).to be true
      end

      it 'returns false when subview is nil' do
        result = tag.send(:validate_subview, nil, site)
        expect(result).to be false
      end
    end
  end
end