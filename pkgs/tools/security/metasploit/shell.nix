# Env to update Gemfile.lock / gemset.nix
{
  pkgs ? import ../../../.. { },
}:
pkgs.stdenv.mkDerivation {
  name = "env";
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = with pkgs; [
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
