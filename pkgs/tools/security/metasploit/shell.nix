# Env to update Gemfile.lock / gemset.nix
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    bundix
    git
    libiconv
    libpcap
    libxml2
    libxslt
    pkg-config
    postgresql
    ruby.devEnv
    sqlite
  ];
}
