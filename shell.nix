{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.ruby
    pkgs.bundler
    pkgs.jekyll
  ];

  shellHook = ''
    echo "Jekyll development environment ready!"
    echo "Ruby version: $(ruby --version)"
    echo "Bundler version: $(bundler --version)"
  '';
}

