require 'digest/md5'

module Redcarpet
  module Render
    class ReVIEW < Base

      def initialize(render_extensions={})
        super()
        @table_num = 0
        @table_id_prefix = "tbl"
        @header_offset = 0
        @link_in_footnote = render_extensions[:link_in_footnote]
        @image_caption = !render_extensions[:disable_image_caption]
        if render_extensions[:header_offset]
          @header_offset = render_extensions[:header_offset]
        end
        @links = {}
      end

      def normal_text(text)
        text
      end

      def escape_inline(text)
        text.gsub(/\}/){'\\}'}
      end

      def escape_href(text)
        text.to_s.gsub(/,/){'\\,'}
      end

      def block_code(code, language)
        code_text = normal_text(code).chomp
        lang = ""
        caption = ""
        if language
          if language =~ /caption=\"(.*)\"/
            caption = "["+$1+"]"
          else
            lang = "#\@# lang: #{language}\n"
          end
        end
        "\n#{lang}//emlist#{caption}{\n#{code_text}\n//}\n"
      end

      def block_quote(quote)
        quote_text = normal_text(quote).chomp
        quote_text.gsub!(/\A\n\n/,'')
        "\n//quote{\n#{quote_text}\n//}\n"
      end

      def block_html(raw_html)
        html_text = raw_html.chomp
        warning = "XXX: BLOCK_HTML: YOU SHOULD REWRITE IT"
        "\n//emlist{\n#{warning}\n#{html_text}\n//}\n"
      end

      def hrule
        "\n//hr\n"
      end

      def codespan(code)
        "@<tt>{#{escape_inline(code)}}"
      end

      def header(title, level, anchor="")
        l = level - @header_offset
        case l
        when 1
          "\n= #{title}\n"
        when 2
          "\n== #{title}\n"
        when 3
          "\n=== #{title}\n"
        when 4
          "\n==== #{title}\n"
        when 5
          "\n===== #{title}\n"
        when 6
          "\n====== #{title}\n"
        else
          raise "too long header"
        end
      end

      def table(header, body)
        @sep = nil
        header_text = ""
        if header
          header_text = "#{header}-----------------\n"
        end
        body.chomp!
        "//table[#{table_id()}][]{\n#{header_text}#{body}\n//}\n"
      end

      def table_row(content)
        @sep = nil
        content+"\n"
      end

      def table_cell(content, alignment)
        sep = @sep
        @sep = "\t"
        "#{sep}#{content}"
      end

      def image(link, title, alt_text)
        filename = File.basename(link,".*")
        if @image_caption
          "//image[#{filename}][#{alt_text}]{\n//}\n"
        else
          "//indepimage[#{filename}]\n"
        end
      end

      def autolink(link, link_type)
        "@<href>{#{escape_href(link)}}"
      end

      def link(link, title, content)
        if @link_in_footnote
          key = Digest::MD5.hexdigest(link)
          @links[key] ||= link
          footnotes(content) + footnote_ref(key)
        else
          "@<href>{#{escape_href(link)},#{escape_inline(content)}}"
        end
      end

      def double_emphasis(text)
        "@<strong>{#{escape_inline(text)}}"
      end

      def emphasis(text)
        "@<b>{#{escape_inline(text)}}"
      end

      def strikethrough(text)
        "@<del>{#{escape_inline(text)}}"
      end

      def linebreak
        "@<br>{}\n"
      end

      def paragraph(text)
        "\n\n#{text}\n\n"
      end

      def list(content, list_type)
        ret = ""
        content.each_line do |item|
          case list_type
          when :ordered
            if item =~ /^ +(\d+\.) (.*)/
              ## XXX not support yet in Re:VIEW
              ret << " #{$1} #{$2.chomp}" << "\n"
            else
              ret << " 1. " << item
            end
          when :unordered
            if item =~ /^ (\*+) (.*)/
              ret << " *#{$1} #{$2.chomp}" << "\n"
            else
              ret << " * " << item
            end
          else
            raise "invalid type: #{list_type}"
          end
        end
        ret
      end

      def list_item(content, list_type)
        content.gsub!(%r<\n//(image|indepimage)\[([^\]]*?)\][^\{]*({\n//})?\n>){
          "@<icon>{"+$2+"}\n"
        }
        case list_type
        when :ordered
          item = content.gsub(/\n(\s+[^0-9])/){$1}.gsub(/\n(\s+[0-9]+[^.])/){$1}.strip
          "#{item}\n"
        when :unordered
          item = content.gsub(/\n(\s*[^* ])/){$1}.strip
          "#{item}\n"
        else
          raise "invalid type: #{list_type}"
        end
      end

      def table_id()
        @table_num += 1
        "#{@table_id_prefix}#{@table_num}"
      end

      def ruby(text)
        rt, rb = text.split(/\|/, 2)
        "@<ruby>{#{escape_inline(rt)},#{escape_inline(rb)}}"
      end

      def tcy(text)
        "@<tcy>{#{escape_inline(text)}}"
      end

      def footnote_ref(number)
        "@<fn>{#{number}}"
      end

      def footnotes(text)
        "#{text}"
      end

      def footnote_def(text,number)
        "\n//footnote[#{number}][#{text.strip}]\n"
      end

      def postprocess(text)
        text + @links.map { |key, link| footnote_def(link, key) }.join
      end
    end
  end
end
