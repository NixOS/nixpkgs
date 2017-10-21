{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "papertrail";
  src = ./.;

  buildInputs = with pkgs; [
    bundix
    bundler
    ruby
  ];

  shellHook = ''
    truncate --size 0 Gemfile.lock
    bundle install --path=vendor/bundle
    rm -rf vendor .bundle
    bundix
  '';
}
