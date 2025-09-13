# Tessellate Jekyll Theme

Tessellate is a Jekyll theme gem based on HTML5 UP's Tessellate template. It provides sectioned layouts for one-page or multi-page sites with a modern responsive design.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Environment Setup
- Install bundler first: `gem install bundler --user-install`
- Add gem bin directory to PATH: `export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"`
- Configure bundle to use local path: `bundle config set --local path 'vendor/bundle'`

### Build and Development Workflow
- Install dependencies: `bundle install` -- takes 20-30 seconds. NEVER CANCEL. Set timeout to 120+ seconds.
- Start development server: `bundle exec jekyll serve --host 0.0.0.0 --port 4000` -- builds in ~0.5 seconds, serves on http://localhost:4000
- Build gem: `gem build *.gemspec` -- takes ~1 second. Creates `tessellate-*.gem` file.
- Install gem locally: `gem install ./tessellate-*.gem --user-install` -- takes 25-30 seconds. NEVER CANCEL. Set timeout to 120+ seconds.

### Testing New Jekyll Sites
To test the theme with a fresh Jekyll site:
```bash
jekyll new test-site --skip-bundle
cd test-site
# Edit Gemfile: replace 'gem "minima"' with 'gem "tessellate"'
# Edit _config.yml: change 'theme: minima' to 'theme: tessellate'
bundle config set --local path 'vendor/bundle'
bundle install  # takes 15-20 seconds
bundle exec jekyll serve --host 0.0.0.0 --port 4000
```

**Note**: The default Jekyll site structure may show build warnings about missing layouts ('post', 'home') since the tessellate theme uses different layout names. This is expected and the site will still build. For proper functionality, use the theme's layout structure as shown in the main repository's `pages/` directory.

## Validation

### Manual Testing Scenarios
Always validate changes by running the following scenario after making modifications:
1. Start the development server: `bundle exec jekyll serve --host 0.0.0.0 --port 4000`
2. Navigate to http://localhost:4000 and verify the homepage loads with:
   - Mountain background header with "Tessellate" title
   - "Learn More" call-to-action button
   - Navigation menu (Home, Project, Contact)
   - Footer with social links
3. Click "Project" link and verify project page loads with multiple sections
4. Click "Documentation" link and verify documentation page loads with:
   - Section One, Two, Three, and Four examples
   - Image grids in Section Two
   - Code highlighting examples
5. Verify all navigation links work correctly

### Build Validation
- Always run `gem build *.gemspec` after making changes to ensure the gem builds successfully
- Test gem installation: `gem install ./tessellate-*.gem --user-install`
- Create a test Jekyll site and verify the theme works correctly (see Testing New Jekyll Sites above)

### No Tests Available
This repository does not have automated tests or linting. Manual validation through browser testing is required.

## Theme Structure and Key Files

### Core Theme Files
- `_layouts/`: Contains page layouts (default.html, page.html, section_*.html)
- `_includes/`: Contains reusable components (header.html, footer.html, navigation.html)
- `_sass/`: Contains SCSS stylesheets (tessellate.scss, custom.scss, navigation.scss)
- `_plugins/`: Contains custom Liquid tags (subview.rb, markdown_split.rb, paragraph_split.rb)
- `assets/`: Contains CSS and image assets
- `pages/`: Example pages demonstrating theme usage

### Configuration Files
- `tessellate.gemspec`: Gem specification file defining dependencies and metadata
- `Gemfile`: Development dependencies (Jekyll ~4.4, kramdown ~2.5, rouge ~4.5)
- `_config.yml`: Default theme configuration with social links and site settings

## Common Tasks

### Customizing Syntax Highlighting
Generate CSS for syntax highlighting themes:
```bash
bundle exec rougify help style  # List available themes
bundle exec rougify style monokai > assets/css/syntax.css  # Generate CSS
```

Available themes: base16, bw, colorful, github, gruvbox, molokai, monokai, pastie, thankful_eyes, tulip

### Theme Layout Usage
Main layout: `page` - takes `header` and `cta` parameters in frontmatter:
```yaml
---
layout: page
header:
  background_image: /assets/images/cover.jpg
  title: "Page Title"
  subtitle: "Page subtitle"
  color: "#fff"
cta:
  link: "#section"
  text: "Call to Action"
---
```

Section layouts: `section_one`, `section_two`, `section_three`, `section_four`
Include subviews with: `{% subview filename.md %}`

Example page structure (see `pages/index/index.md` for reference):
```markdown
---
layout: page
permalink: /
header:
  background: |
    linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)),
    center center/cover no-repeat url(/assets/images/IMG_0004.jpg)
  title: Tessellate
  subtitle: A Jekyll Theme
  color: "#fff"
cta:
  link: /project/
  text: "Learn More"
---

{% subview about_section.md %}
```

### Dependencies and Compatibility
- Ruby: 3.2.3+ (CI uses 3.3.4)
- Jekyll: ~4.3 (tested with 4.4.1)
- Bundler: 2.5.16+ (works with 2.7.2)
- Main dependencies: kramdown, rouge, sass-embedded

## Development Environment

### Repository Structure
```
.
├── .github/workflows/gem-push.yml  # CI for publishing gems
├── .gitignore                      # Excludes _site, vendor, .sass-cache
├── Gemfile                         # Development dependencies
├── Gemfile.lock                    # Locked dependency versions
├── README.md                       # Installation and usage docs
├── _config.yml                     # Default theme configuration
├── _data/                          # Theme data files
├── _includes/                      # Reusable template components
├── _layouts/                       # Page layouts
├── _plugins/                       # Custom Liquid tags
├── _sass/                          # SCSS stylesheets
├── _showcase/                      # Preview images
├── assets/                         # CSS, JS, and image assets
├── pages/                          # Example pages
├── shell.nix                       # Nix development shell (optional)
└── tessellate.gemspec              # Gem specification
```

### CI/CD Pipeline
- GitHub Actions workflow builds and publishes gem on push to main
- Publishes to both GitHub Packages and RubyGems
- No automated testing - relies on manual validation

### Optional Nix Support
A `shell.nix` file is provided for Nix users but is not required. Standard Ruby/Bundler workflow works without Nix.