module Jekyll
  module MarkdownSplit
    def markdown_split(content)
      content.split(/^\s*[-*_]{3,}\s*$/m)
    end
  end
end

Liquid::Template.register_filter(Jekyll::MarkdownSplit)
