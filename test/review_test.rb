# coding: utf-8
rootdir = File.dirname(File.dirname(__FILE__))
$LOAD_PATH.unshift "#{rootdir}/lib"

if defined? Encoding
  Encoding.default_internal = 'UTF-8'
end

require 'test/unit'
require 'md2review'
require 'md2review/markdown'

class ReVIEWTest < Test::Unit::TestCase

  def setup
    @markdown = MD2ReVIEW::Markdown.new({},{})
  end

  def render_with(flags, text, render_flags = {})
    MD2ReVIEW::Markdown.new(render_flags, flags).render(text)
  end

  def test_that_simple_one_liner_goes_to_review
    assert_respond_to @markdown, :render
    assert_equal "\n\nHello World.\n\n", @markdown.render("Hello World.\n")
  end

  def test_href
    assert_respond_to @markdown, :render
    assert_equal "\n\n@<href>{http://exmaple.com,example}\n\n", @markdown.render("[example](http://exmaple.com)\n")
  end

  def test_href_with_comma
    assert_respond_to @markdown, :render
    assert_equal "\n\n@<href>{http://exmaple.com/foo\\,bar,example}\n\n", @markdown.render("[example](http://exmaple.com/foo,bar)")
  end

  def test_href_in_footnote
    text = %Q[aaa [foo](http://example.jp/foo), [bar](http://example.jp/bar), [foo2](http://example.jp/foo)]
    rd = MD2ReVIEW::Markdown.new({:link_in_footnote => true},{}).render(text)
    assert_equal %Q|\n\naaa foo@<fn>{3ccd7167b80081c737b749ad1c27dcdc}, bar@<fn>{9dcab303478e38d32d83ae19daaea9f6}, foo2@<fn>{3ccd7167b80081c737b749ad1c27dcdc}\n\n\n//footnote[3ccd7167b80081c737b749ad1c27dcdc][http://example.jp/foo]\n\n//footnote[9dcab303478e38d32d83ae19daaea9f6][http://example.jp/bar]\n|, rd
  end

  def test_href_with_emphasised_anchor
    assert_equal "\n\n@<href>{http://exmaple.com/,example}\n\n", @markdown.render("[*example*](http://exmaple.com/)")
  end

  def test_href_with_double_emphasised_anchor
    assert_equal "\n\n@<href>{http://exmaple.com/,example}\n\n", @markdown.render("[**example**](http://exmaple.com/)")
  end

  def test_href_with_codespan_anchor
    assert_equal "\n\n@<href>{http://exmaple.com/,example}\n\n", @markdown.render("[`example`](http://exmaple.com/)")
  end

  def test_emphasis_with_href
    assert_respond_to @markdown, :render
    assert_equal "\n\n@<b>{{hello\\} }@<href>{http://exmaple.com/foo\\,bar,example}@<b>{ world}\n\n", @markdown.render("*{hello} [example](http://exmaple.com/foo,bar) world*")
  end

  def test_header
    assert_respond_to @markdown, :render
    assert_equal "\n= AAA\n\n\nBBB\n\n\n== ccc\n\n\nddd\n\n", @markdown.render("#AAA\nBBB\n\n##ccc\n\nddd\n")
  end

  def test_header56
    assert_respond_to @markdown, :render
    assert_equal "\n===== AAA\n\n\nBBB\n\n\n====== ccc\n\n\nddd\n\n", @markdown.render("#####AAA\nBBB\n\n######ccc\n\nddd\n")
  end

  def test_header_attributes
    assert_respond_to @markdown, :render
    assert_equal "\n\#@# header_attribute: {-}\n= AAA\n\n\#@# header_attribute: {\#foo .bar title=hoge}\n= BBB\n", @markdown.render("\#AAA  {-}\n\n\#BBB {\#foo .bar title=hoge}\n\n")
  end

  def test_header_attributes_without_space
    assert_respond_to @markdown, :render
    assert_equal "\n\#@# header_attribute: {-}\n= AAA\n\n\= BBB@<tt>{test}\n",
                 @markdown.render("\#AAA  {-}\n\n\#BBB@<tt>{test}\n\n")
  end

  def test_image
    assert_equal "\n\n//image[image][test]{\n//}\n\n\n", @markdown.render("![test](path/to/image.jpg)\n")
  end

  def test_indented_image
    assert_equal "\n\n//image[image][test]{\n//}\n\n\n", @markdown.render(" ![test](path/to/image.jpg)\n")
  end

  def test_indepimage
    rev = render_with({}, "![test](path/to/image.jpg)\n",{:disable_image_caption => true})
    assert_equal "\n\n//indepimage[image]\n\n\n", rev
  end

  def test_nested_ulist
    assert_equal " * aaa\n ** bbb\n * ccc\n", @markdown.render("- aaa\n  - bbb\n- ccc\n")
  end

  def test_olist
    assert_equal " 1. aaa\n 1. bbb\n 1. ccc\n", @markdown.render("1. aaa\n2. bbb\n3. ccc\n")
  end

  def test_nested_olist
    ## XXX not support yet in Re:VIEW
    assert_equal " 1. aaa\n 1. bbb\n 1. ccc\n", @markdown.render("1. aaa\n   2. bbb\n3. ccc\n")
  end

  def test_olist_image
    assert_equal " 1. aaa@<icon>{foo}\n 1. bbb\n 1. ccc\n", @markdown.render("1. aaa\n    ![test](foo.jpg)\n2. bbb\n3. ccc\n")
  end

  def test_olist_image2
    assert_equal " 1. aaa@<br>{}@<icon>{foo}\n 1. bbb\n 1. ccc\n", @markdown.render("1. aaa  \n    ![test](foo.jpg)\n2. bbb\n3. ccc\n")
  end

  def test_table_with_empty_cell
    rd = render_with({:tables => true}, %Q[\n\n| a  |  b |  c |\n|----|----|----|\n| A  | B  | C  |\n|    | B  |  C |\n| .A | B  |  C |\n\n])
    assert_equal "//table[tbl1][]{\na\tb\tc\n-----------------\nA\tB\tC\n.\tB\tC\n..A\tB\tC\n//}\n", rd
  end

  def test_table_with_caption
    rd = render_with({:tables => true}, <<-EOB, {:table_caption => true})

Table: caption test

| a  |  b |  c |
|----|----|----|
| A  | B  | C  |
|    | B  |  C |
| .A | B  |  C |
    EOB
    assert_equal <<-EOB, rd
//table[tbl1][caption test]{
a\tb\tc
-----------------
A\tB\tC
.\tB\tC
..A\tB\tC
//}
EOB
  end

  def test_code_fence_with_caption
    rd = render_with({:fenced_code_blocks => true}, %Q[~~~ {caption="test"}\ndef foo\n  p "test"\nend\n~~~\n])
    assert_equal %Q[\n//emlist[test]{\ndef foo\n  p "test"\nend\n//}\n], rd
  end

  def test_code_fence_without_flag
    rd = render_with({}, %Q[~~~ {caption="test"}\ndef foo\n  p "test"\nend\n~~~\n])
    assert_equal %Q[\n\n~~~ {caption="test"}\ndef foo\n  p "test"\nend\n~~~\n\n], rd
  end

  def test_code_fence_with_lang
    rd = render_with({:fenced_code_blocks => true}, %Q[~~~ruby\ndef foo\n  p "test"\nend\n~~~\n])
    assert_equal %Q[\n//emlist[][ruby]{\ndef foo\n  p "test"\nend\n//}\n], rd
  end

  def test_code_fence_with_console
    rd = render_with({:fenced_code_blocks => true}, %Q[~~~console\ndef foo\n  p "test"\nend\n~~~\n])
    assert_equal %Q[\n//emlist[][console]{\ndef foo\n  p "test"\nend\n//}\n], rd
    rd = render_with({:fenced_code_blocks => true},
                      %Q[~~~console\ndef foo\n  p "test"\nend\n~~~\n],
                     {:enable_cmd => true})
    assert_equal %Q[\n//cmd{\ndef foo\n  p "test"\nend\n//}\n], rd
  end

  def test_group_ruby
    rd = render_with({:ruby => true}, "{電子出版|でんししゅっぱん}を手軽に\n")
    assert_equal %Q[\n\n@<ruby>{電子出版,でんししゅっぱん}を手軽に\n\n], rd
  end

  def test_tcy
    rd = render_with({:tcy => true}, "昭和^53^年\n")
    assert_equal %Q[\n\n昭和@<tcy>{53}年\n\n], rd
  end

  def test_math
    rd = render_with({}, "その結果、$$y=ax^2+bx+c$$の式が得られます。",{:math => true})
    assert_equal %Q[\n\nその結果、@<m>{y=ax^2+bx+c}の式が得られます。\n\n], rd
  end

  def test_multi_math
    rd = render_with({}, "その結果、$$y=a_2x^2+b_2x+c_2$$の式が得られます。$$a_2$$は2次の係数、$$b_2$$は1次の係数、$$c_2$$は定数です。",{:math => true})
    assert_equal %Q[\n\nその結果、@<m>{y=a_2x^2+b_2x+c_2}の式が得られます。@<m>{a_2}は2次の係数、@<m>{b_2}は1次の係数、@<m>{c_2}は定数です。\n\n], rd
  end

  def test_math2
    rd = render_with({}, <<-'EOB',{:math => true})
$$X = \{ {x_1}, \cdots ,{x_n} \}$$、$$m$$、$${\mu _X}$$、$$\sigma _X^2$$、$$\{ {\hat x_1}, \cdots ,{\hat x_n} \}$$

$$\mathbf{W} = ({w_1}, \cdots ,{w_n})$$、$$\sqrt {w_1^2 + \cdots  + w_n^2} $$、$$\left| {w_1^{}} \right| + \left| {w_2^{}} \right| +  \cdots  + \left| {w_n^{}} \right|$$。
EOB
    assert_equal <<-'EOB', rd


@<m>{X = \{ {x_1\}, \cdots ,{x_n\} \\\}}、@<m>{m}、@<m>{{\mu _X\}}、@<m>{\sigma _X^2}、@<m>{\{ {\hat x_1\}, \cdots ,{\hat x_n\} \\\}}



@<m>{\mathbf{W\} = ({w_1\}, \cdots ,{w_n\})}、@<m>{\sqrt {w_1^2 + \cdots  + w_n^2\} }、@<m>{\left| {w_1^{\}\} \right| + \left| {w_2^{\}\} \right| +  \cdots  + \left| {w_n^{\}\} \right|}。

EOB
  end

  def test_no_math
    rd = render_with({}, "その結果、$$y=ax^2+bx+c$$の式が得られます。",{:math => false})
    assert_equal %Q[\n\nその結果、$$y=ax^2+bx+c$$の式が得られます。\n\n], rd
  end

  def test_math_block
    rd = render_with({:fenced_code_blocks => true}, <<-EOB,{:math => true})
求める式は以下のようになります。

```math
\frac{n!}{k!(n-k)!} = \binom{n}{k}
```
EOB
    assert_equal <<-EOB, rd


求める式は以下のようになります。


//texequation{
\frac{n!}{k!(n-k)!} = \binom{n}{k}
//}
EOB
  end

  def test_footnote
    rd = render_with({:footnotes=>true}, "これは*脚注*付き[^1]の段落です。\n\n\n[^1]: そして、これが脚注です。\n")
    assert_equal %Q|\n\nこれは@<b>{脚注}付き@<fn>{1}の段落です。\n\n\n//footnote[1][そして、これが脚注です。]\n|, rd
  end

  def test_autolink
    rd = render_with({:autolink => true}, "リンクの[テスト](http://example.jp/test)です。\nhttp://example.jp/test2/\n")
    assert_equal %Q[\n\nリンクの@<href>{http://example.jp/test,テスト}です。\n@<href>{http://example.jp/test2/}\n\n], rd
  end

  def test_no_autolink
    rd = render_with({}, "リンクの[テスト](http://example.jp/test)です。\nhttp://example.jp/test2/\n")
    assert_equal %Q[\n\nリンクの@<href>{http://example.jp/test,テスト}です。\nhttp://example.jp/test2/\n\n], rd
  end

end
