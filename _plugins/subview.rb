module Jekyll
  class SubviewTag < Liquid::Tag
    def initialize(tag_name, path, tokens)
      super
      @path = path.strip
    end

    def render(context)
      site = context.registers[:site]
      subview = find_subview_document(site)

      return "" unless validate_subview(subview, site)

      render_subview(subview, site, context)
    rescue => e
      Jekyll.logger.error "Subview Error:", "Failed to render #{@path}: #{e.message}"
      Jekyll.logger.error "\n#{e.backtrace.join("\n")}"
      ""
    end

    private

    def find_subview_document(site)
      # Match by path, relative path, or basename
      site.pages.find { |p|
        p.path == @path || p.relative_path == @path || File.basename(p.path) == @path
      }
    end

    def validate_subview(subview, site)
      return true if subview
      Jekyll.logger.error "Subview Error:", "Document #{@path} not found"
      Jekyll.logger.error "\n#{e.backtrace.join("\n")}"
      false
    end

    def render_subview(subview, site, parent_context)
      Jekyll.logger.debug "Subview:",
        "Rendering subview document #{@path} inside #{parent_context.registers[:page]['path']}"
      # Render the subview's content and return the output
      subview.output = Jekyll::Renderer.new(site, subview, site.site_payload).run()
      subview.output
    end
  end
end

Liquid::Template.register_tag("subview", Jekyll::SubviewTag)

