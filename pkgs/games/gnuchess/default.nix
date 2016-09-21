{stdenv, fetchurl, flex}:
let
  s = # Generated upstream information
  rec {
    baseName="gnuchess";
    version="6.2.3";
    name="${baseName}-${version}";
    url="mirror://gnu/chess/${name}.tar.gz";
    sha256="10hvnfhj9bkpz80x20jgxyqvgvrcgfdp8sfcbcrf1dgjn9v936bq";
  };
  buildInputs = [
    flex
  ];
in
stdenv.mkDerivation rec {
  inherit (s) name version;
  src = fetchurl {
    inherit (s) url sha256;
  };
  inherit buildInputs;
  meta = {
    inherit (s) version;
    description = "GNU Chess engine";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
