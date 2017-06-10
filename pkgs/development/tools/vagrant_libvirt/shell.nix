# Env to update Gemfile.lock / gemset.nix
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    pkgconfig
    libvirt
    libxml2
    zlib
    ruby
    bundix
  ];
}
