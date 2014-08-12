{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="jq";
    version="1.4";
    name="${baseName}-${version}";
    hash="17dk17h7qj6xpnsbc09qwsqkm6r7jhqbfkjvwq246yxmpsx4334r";
    url="http://stedolan.github.io/jq/download/source/jq-1.4.tar.gz";
    sha256="17dk17h7qj6xpnsbc09qwsqkm6r7jhqbfkjvwq246yxmpsx4334r";
  };
  buildInputs = [
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  meta = {
    inherit (s) version;
    description = ''A lightweight and flexible command-line JSON processor'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
