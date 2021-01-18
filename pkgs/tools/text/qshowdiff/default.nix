{lib, stdenv, fetchurl, qt4, perl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "qshowdiff";
  version = "1.2";

  src = fetchurl {
    url = "https://github.com/danfis/qshowdiff/archive/v${version}.tar.gz";
    sha256 = "027959xbzvi5c2w9y1x122sr5i26k9mvp43banz2wln6gd860n1a";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ qt4 perl ];

  configurePhase = ''
    mkdir -p $out/{bin,man/man1}
    makeFlags="PREFIX=$out CC=$CXX"
  '';

  meta = {
    homepage = "http://qshowdiff.danfis.cz/";
    description = "Colourful diff viewer";
    license = lib.licenses.gpl3Plus;
  };
}
