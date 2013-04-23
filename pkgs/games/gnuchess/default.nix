{stdenv, fetchurl, flex}:
let
  s = # Generated upstream information
  rec {
    baseName="gnuchess";
    version="6.0.3";
    name="${baseName}-${version}";
    hash="01ff8qd8pk39c6pv24wbcqkx78kvay8rxvgxqq9cqp9gqv39jfkw";
    url="http://ftp.gnu.org/gnu/chess/gnuchess-6.0.3.tar.gz";
    sha256="01ff8qd8pk39c6pv24wbcqkx78kvay8rxvgxqq9cqp9gqv39jfkw";
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
