{ pkgs ? import <nixpkgs> {} }:

let
  gems = pkgs.bundlerEnv {
    inherit (pkgs) ruby;
    name = "shell";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

in
pkgs.mkShell {
  buildInputs = [
    pkgs.ruby
    pkgs.bundler
    gems
  ];

  shellHook = ''
    export RUBY_VERSION=$(ruby -e 'print RUBY_VERSION')
    export GEM_HOME="${gems}/lib/ruby/gems/$RUBY_VERSION"
    export GEM_PATH="${gems}/lib/ruby/gems/$RUBY_VERSION"

    echo "Jekyll development environment ready!"
    echo "Ruby version: $(ruby --version)"
    echo "Bundle version: $(bundle --version)"
  '';
}

