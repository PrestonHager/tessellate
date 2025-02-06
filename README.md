# tessellate

Tessellate theme based on [HTML5 UP's Tessellate template][0].
Aimed at sectioned content allowing for a wide range of layouts.

## Installation

Add this line to your Jekyll site's `Gemfile`:

```ruby
gem "tessellate"
```

And add this line to your Jekyll site's `_config.yml`:

```yaml
theme: tessellate
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tessellate

## Usage

TODO: Write usage instructions here. Describe your available layouts, includes, sass and/or assets.

The basic layout is `page`, it takes a `header` and `cta` parameter.

```yaml
---
layout: page
header:
  background_image: /assets/images/cover.jpg
  title: "Tessellate"
  subtitle: |
    A Jekyll theme based on <a href="https://html5up.net/tessellate">HTML5 UP's Tessellate template</a>
  color: "#000"
cta:
  link: "#first"
  text: "Get Started"
---
```

Every subview then takes a `header` and `cta` parameter.
Both parameters are optional.
If not included, the header/link will be hidden.

Define subviews in a seperate file such as `index_section_one.md`.
The layout is then whatever section layout you want to use.
The theme comes with sections one, two, and three.
For example, to define a section one on the index page use:

```yaml
---
layout: section_one
header:
  title: "Section One"
cta:
  link: "#second"
  text: "Learn More"
---

The section content goes here.
```

Finally, we must include it in the main `index.md` page using the `subview`
liquid tag.

```liquid
---
Front matter goes here...
---

{% subview index_section_one.md %}
{% subview index_section_two.md %}
{% subview index_section_three.md %}
```

## Customization

TODO: Write customization instructions here. Describe any available variables,
layout options, and/or custom URL options.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/PrestonHager/tessellate. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](https://www.contributor-covenant.org/) code of
conduct.

## Development

To set up your environment to develop this theme, run `bundle install`.

Your theme is setup just like a normal Jekyll site! To test your theme, run
`bundle exec jekyll serve` and open your browser at `http://localhost:4000`.
This starts a Jekyll server using your theme. Add pages, documents, data, etc.
like normal to test your theme's contents. As you make modifications to your
theme and to your content, your site will regenerate and you should see the
changes in the browser after a refresh, just like normal.

When your theme is released, only the files in `_layouts`, `_includes`, `_sass`
and `assets` tracked with Git will be bundled.
To add a custom directory to your theme-gem, please edit the regexp in
`tessellate.gemspec` accordingly.

## License

The theme is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).


[0]: https://html5up.net/tessellate

