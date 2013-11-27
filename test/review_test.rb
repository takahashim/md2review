# coding: UTF-8
rootdir = File.dirname(File.dirname(__FILE__))
$LOAD_PATH.unshift "#{rootdir}/lib"

if defined? Encoding
  Encoding.default_internal = 'UTF-8'
end

require 'test/unit'
require 'redcarpet'
require 'redcarpet/render/review'

class ReVIEWTest < Test::Unit::TestCase

  def setup
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::ReVIEW.new({}))
  end

  def render_with(flags, text)
    Redcarpet::Markdown.new(Redcarpet::Render::ReVIEW, flags).render(text)
  end

  def test_that_simple_one_liner_goes_to_review
    assert_respond_to @markdown, :render
    assert_equal "\n\nHello World.\n", @markdown.render("Hello World.")
  end

  def test_href
    assert_respond_to @markdown, :render
    assert_equal "\n\n@<href>{http://exmaple.com,example}\n", @markdown.render("[example](http://exmaple.com)")
  end

  def test_href_with_comma
    assert_respond_to @markdown, :render
    assert_equal "\n\n@<href>{http://exmaple.com/foo\\,bar,example}\n", @markdown.render("[example](http://exmaple.com/foo,bar)")
  end

end
