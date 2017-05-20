# Env to update Gemfile.lock / gemset.nix
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    sqlite
    libpcap
    postgresql
    libxml2
    libxslt
    pkgconfig
    bundix
  ];
}
