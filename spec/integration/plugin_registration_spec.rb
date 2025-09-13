# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe 'Jekyll Plugin Registration' do
  describe 'Liquid filter registration' do
    it 'registers MarkdownSplit filter' do
      # Mock Liquid::Template to capture filter registrations
      registered_filters = []
      
      allow(Liquid::Template).to receive(:register_filter) do |filter_module|
        registered_filters << filter_module
      end
      
      # Load plugin (it will register with our mock)
      load File.join(__dir__, '../../_plugins/markdown_split.rb')
      
      expect(registered_filters).to include(Jekyll::MarkdownSplit)
    end

    it 'registers ParagraphSplit filter' do
      registered_filters = []
      
      allow(Liquid::Template).to receive(:register_filter) do |filter_module|
        registered_filters << filter_module
      end
      
      load File.join(__dir__, '../../_plugins/paragraph_split.rb')
      
      expect(registered_filters).to include(Jekyll::ParagraphSplit)
    end
  end

  describe 'Liquid tag registration' do
    it 'registers subview tag' do
      registered_tags = []
      
      allow(Liquid::Template).to receive(:register_tag) do |name, tag_class|
        registered_tags << { name: name, class: tag_class }
      end
      
      # Load SubviewTag plugin
      load File.join(__dir__, '../../_plugins/subview.rb')
      
      subview_registration = registered_tags.find { |tag| tag[:name] == 'subview' }
      expect(subview_registration).not_to be_nil
      expect(subview_registration[:class]).to eq(Jekyll::SubviewTag)
    end
  end
end