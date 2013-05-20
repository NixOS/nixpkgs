{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="jq";
    version="1.3";
    name="${baseName}-${version}";
    hash="1mzy9cj3d19y1m56mwk6slls543gnlhz8302hmnxkhdzdb1j6gv2";
    url="http://stedolan.github.io/jq/download/source/jq-1.3.tar.gz";
    sha256="1mzy9cj3d19y1m56mwk6slls543gnlhz8302hmnxkhdzdb1j6gv2";
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
