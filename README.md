# md2review

[![Build Status](https://api.travis-ci.org/takahashim/md2review.png)](https://travis-ci.org/takahashim/md2review)

md2review is a converter from Markdown into ReVIEW.
This command uses Redcarpet gem to parse markdown.

## Installation

Add this line to your application's Gemfile:

    gem 'md2review'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install md2review

## Usage

You can use the commmand md2review as:

    $ md2review your-document.md > your-document.re

## History

* 1.6.0
    * special attribute in header need a separator(U+0020) to distinguish from Re:VIEW inline markup
      (reported by @himajin315 and @yasulab)
* 1.5.0
    * support language on code block
    * add option --render-enable-cmd
* 1.4.0
    * fix handling empty cell in //table
    * support header attributes in PHP Markdown Extra
* 1.3.0
    * allow images in list items (with @<icon>)
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
