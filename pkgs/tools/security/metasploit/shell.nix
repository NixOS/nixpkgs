# Env to update Gemfile.lock / gemset.nix
with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "env";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    bundix
    git
    libiconv
    libpcap
    libxml2
    libxslt
    postgresql
    ruby.devEnv
    sqlite
  ];
}
