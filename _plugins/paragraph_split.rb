module Jekyll
  module ParagraphSplit
    def paragraph_split(content, n)
      # Split content into x amount of paragraphs based on the sentences.
      # Split along each sentence boundary of ., !, ?, and newline.
      # Keep the delimiter in the resulting array.
      sentences = content.split(/(?<=[.!?])\s+|(?<=\n)\s+|^\s*[-*_]{3,}\s*$/m)
      Jekyll.logger.info "Sentences: #{sentences.inspect}"
      # Assemble the paragraphs
      sentences
    end
  end
end

Liquid::Template.register_filter(Jekyll::ParagraphSplit)

