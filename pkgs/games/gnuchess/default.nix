{stdenv, fetchurl, flex}:
let
  s = # Generated upstream information
  rec {
    baseName="gnuchess";
    version="6.1.2";
    name="${baseName}-${version}";
    hash="15k6w9gycp566i0pa7ccajj9v3pw1mz1v62g1ni7czgs3j7i588l";
    url="http://ftp.gnu.org/gnu/chess/gnuchess-6.1.2.tar.gz";
    sha256="15k6w9gycp566i0pa7ccajj9v3pw1mz1v62g1ni7czgs3j7i588l";
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
