# Env to update Gemfile.lock / gemset.nix

with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    ruby.devEnv
    gnumake
    bundix
  ];
}
