{stdenv, fetchurl, flex}:
let
  s = # Generated upstream information
  rec {
    baseName="gnuchess";
    version="6.2.4";
    name="${baseName}-${version}";
    url="mirror://gnu/chess/${name}.tar.gz";
    sha256="1vw2w3jwnmn44d5vsw47f8y70xvxcsz9m5msq9fgqlzjch15qhiw";
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
