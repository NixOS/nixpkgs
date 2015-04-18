{stdenv, fetchurl, flex}:
let
  s = # Generated upstream information
  rec {
    baseName="gnuchess";
    version="6.2.1";
    name="${baseName}-${version}";
    hash="01pdmsxvgzi4fmvsclvy123z5js2aa81fjx12z5pni1ramrapjhp";
    url="http://ftp.gnu.org/gnu/chess/gnuchess-6.2.1.tar.gz";
    sha256="01pdmsxvgzi4fmvsclvy123z5js2aa81fjx12z5pni1ramrapjhp";
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
