# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "tessellate"
  spec.version       = "0.1.5"
  spec.authors       = ["Preston Hager"]
  spec.email         = ["preston@hagerfamily.com"]

  spec.summary       = "Tessellate Jekyll theme based on Tessellate from HTML5UP"
  spec.homepage      = "https://github.com/PrestonHager/tessellate"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_data|_layouts|_includes|_sass|LICENSE|README|_config\.yml)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.3"
end
