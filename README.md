# md2review

[![Gem Version](https://badge.fury.io/rb/md2review.svg)](https://badge.fury.io/rb/md2review)
[![Build Status](https://secure.travis-ci.org/takahashim/md2review.svg)](https://travis-ci.org/takahashim/md2review)

md2review is a CLI tool to convert from Markdown into Re:VIEW (http://reviewml.org/ ).
This command uses Redcarpet gem to parse markdown.

## Usage

You can use the commmand md2review as:

    $ md2review [options] your-document.md > your-document.re

### Options

* `--version`: show version
* `--help`: show help
* `--render-header-offset = N`: use offset of header levels
* `--render-disable-image-caption`: disable image caption; coverting into `//indepimage`
* `--render-link-in-footnote`: enable links in footnote.
* `--render-enable-cmd`: support `//cmd{...//}` for `shell-session` and `console` blocks
* `--render-math`: support `@<m>{...}` and `//texequation{...}`
* `--render-table-cation`: support table caption before table like `Table: some captions`
* `--parse-no-intra-emphasis`: do not parse emphasis inside of words.
* `--parse-autolink`: parse links even when they are not enclosed in `<>` characters.
* `--render-empty-image-caption`: use `//image` with caption and use `//indepimage` without caption


## Installation

Add this line to your application's Gemfile:

    gem 'md2review'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install md2review

## History

### v1.11.0
* add: option --empty-image-caption: switch to use `//image` or `//indepimage` with caption

### v1.10.0
* add: option --image-table to support `//imgtable` with `![Table:foo](...)`
* fix: olist before/after ulist

### v1.9.0
* fix: fix math support for complex cases

### v1.8.0
* add: option --version
* add: option --render-math to support `@<m>{...}` and `//texequation{\n...\n}\n`
* add: option --render-table-caption to support `Table: caption`

### v1.7.0
* fix: when href in emphasis (@hanachin)
* fix: spaces before image block (@hanachin)
* fix: remove inline markup in href content (@hanachin)

### v1.6.0
* special attribute in header need a separator(U+0020) to distinguish from Re:VIEW inline markup
  (reported by @himajin315 and @yasulab)

### v1.5.0
* support language on code block
* add option --render-enable-cmd

### v1.4.0
* fix handling empty cell in `//table`
* support header attributes in PHP Markdown Extra

### v1.3.0
* allow images in list items (with `@<icon>`)
* add option --disable-image-caption
* allow 6th header level
* add option --render-link-in-footnote (by @masarakki)
* support inline markup in footnote (by @hamano)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
