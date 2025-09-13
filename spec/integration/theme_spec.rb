# frozen_string_literal: true

require_relative '../spec_helper'
require 'yaml'

RSpec.describe 'Jekyll Theme Integration' do
  let(:config_path) { File.join(__dir__, '../../_config.yml') }
  let(:gemspec_path) { File.join(__dir__, '../../tessellate.gemspec') }
  let(:plugins_dir) { File.join(__dir__, '../../_plugins') }

  describe 'theme configuration' do
    it 'has a valid _config.yml file' do
      expect(File.exist?(config_path)).to be true
      
      config = YAML.load_file(config_path)
      expect(config).to be_a(Hash)
    end

    it 'specifies required markdown processor' do
      config = YAML.load_file(config_path)
      expect(config['markdown']).to eq('kramdown')
      expect(config['highlighter']).to eq('rouge')
    end

    it 'has kramdown configuration' do
      config = YAML.load_file(config_path)
      expect(config['kramdown']).to be_a(Hash)
      expect(config['kramdown']['input']).to eq('GFM')
    end

    it 'includes default socials configuration' do
      config = YAML.load_file(config_path)
      expect(config['socials']).to be_an(Array)
      expect(config['socials']).not_to be_empty
      
      # Check structure of social entries
      config['socials'].each do |social|
        expect(social).to have_key('name')
        expect(social).to have_key('link')
      end
    end

    it 'has copyright information' do
      config = YAML.load_file(config_path)
      expect(config['copyright']).to be_a(String)
      expect(config['copyright']).not_to be_empty
    end
  end

  describe 'gemspec configuration' do
    it 'has a valid gemspec file' do
      expect(File.exist?(gemspec_path)).to be true
      
      # Load and validate gemspec
      spec = Gem::Specification.load(gemspec_path)
      expect(spec).to be_a(Gem::Specification)
      expect(spec.name).to eq('tessellate')
      expect(spec.version).to be_a(Gem::Version)
    end

    it 'includes Jekyll as a runtime dependency' do
      spec = Gem::Specification.load(gemspec_path)
      jekyll_dep = spec.runtime_dependencies.find { |dep| dep.name == 'jekyll' }
      
      expect(jekyll_dep).not_to be_nil
      expect(jekyll_dep.requirement.to_s).to include('4.3')
    end

    it 'has required metadata' do
      spec = Gem::Specification.load(gemspec_path)
      
      expect(spec.authors).not_to be_empty
      expect(spec.email).not_to be_empty
      expect(spec.summary).not_to be_empty
      expect(spec.homepage).to include('github.com')
      expect(spec.license).to eq('MIT')
    end
  end

  describe 'plugins structure' do
    it 'has plugins directory' do
      expect(Dir.exist?(plugins_dir)).to be true
    end

    it 'contains expected plugin files' do
      expected_plugins = %w[
        paragraph_split.rb
        markdown_split.rb
        subview.rb
      ]
      
      expected_plugins.each do |plugin|
        plugin_path = File.join(plugins_dir, plugin)
        expect(File.exist?(plugin_path)).to be true
      end
    end

    it 'plugins are valid Ruby files' do
      Dir.glob(File.join(plugins_dir, '*.rb')).each do |plugin_file|
        expect { load plugin_file }.not_to raise_error
      end
    end
  end

  describe 'theme structure' do
    let(:theme_dirs) do
      %w[_layouts _includes _sass assets]
    end

    it 'has required theme directories' do
      theme_dirs.each do |dir|
        dir_path = File.join(__dir__, '../../', dir)
        expect(Dir.exist?(dir_path)).to be true
      end
    end

    it 'includes necessary files in gemspec' do
      spec = Gem::Specification.load(gemspec_path)
      
      # Check that important directories are included in files
      expected_patterns = %w[assets _data _layouts _includes _sass]
      
      expected_patterns.each do |pattern|
        matching_files = spec.files.select { |f| f.start_with?(pattern) }
        expect(matching_files).not_to be_empty, "Expected files matching pattern '#{pattern}'"
      end
    end
  end

  describe 'theme functionality' do
    it 'loads plugins without errors' do
      expect do
        load File.join(plugins_dir, 'markdown_split.rb')
        load File.join(plugins_dir, 'paragraph_split.rb')
        load File.join(plugins_dir, 'subview.rb')
      end.not_to raise_error
    end

    it 'registers Liquid filters correctly' do
      # This tests that the plugins can be loaded and would register
      # their filters with Liquid in a real Jekyll environment
      
      # Create a test class to include the modules
      test_class = Class.new do
        require_relative '../../_plugins/markdown_split'
        require_relative '../../_plugins/paragraph_split'
        include Jekyll::MarkdownSplit
        include Jekyll::ParagraphSplit
      end
      
      instance = test_class.new
      
      # Test that the methods are available
      expect(instance.respond_to?(:markdown_split)).to be true
      expect(instance.respond_to?(:paragraph_split)).to be true
    end
  end
end