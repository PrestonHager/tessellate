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
      Jekyll.logger.info "Subview:", "Found subview document #{@path}"

      render_subview(subview, site, context)
    rescue => e
      Jekyll.logger.error "Subview Error:", "Failed to render #{@path}: #{e.message}"
      Jekyll.logger.error "\n#{e.backtrace.join("\n")}"
      ""
    end

    private

    def find_subview_document(site)
      # Search the path, the relative path, and the basename
      site.pages.find { |p|
        if p.path == @path || p.relative_path == @path || File.basename(p.path) == @path
          @path = p.path
          return p
        end
      }
    end

    def validate_subview(subview, site)
      return true if subview
      Jekyll.logger.error "Subview Error:", "Document #{@path} not found"
      false
    end

    def render_subview(subview, site, parent_context)
      Jekyll.logger.info "Subview:", "Rendering subview document #{@path} inside #{parent_context.registers[:page]["path"]}"
      # Also set the subview in the data to true
      subview.data["subview"] = true
      subview.renderer.run()
    end
  end
end

Liquid::Template.register_tag("subview", Jekyll::SubviewTag)

