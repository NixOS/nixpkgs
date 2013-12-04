{stdenv, fetchurl, flex}:
let
  s = # Generated upstream information
  rec {
    baseName="gnuchess";
    version="6.1.1";
    name="${baseName}-${version}";
    hash="1jckpg1qi1vjr3pqs0dnip3rmn0mgklx63xflrpqiv3cx2qlz8kn";
    url="http://ftp.gnu.org/gnu/chess/gnuchess-6.1.1.tar.gz";
    sha256="1jckpg1qi1vjr3pqs0dnip3rmn0mgklx63xflrpqiv3cx2qlz8kn";
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
