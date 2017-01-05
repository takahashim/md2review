require 'redcarpet'
require 'redcarpet/render/review'

module MD2ReVIEW
  class Markdown
    def initialize(render_options, parser_options)
      ## Redcarpet only
      render = Redcarpet::Render::ReVIEW.new(render_options)
      @markdown = Redcarpet::Markdown.new(render, parser_options)
    end

    def render(text)
      @markdown.render(text)
    end
  end
end
