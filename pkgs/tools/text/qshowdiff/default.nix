{stdenv, fetchurl, qt4, perl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "qshowdiff-${version}";
  version = "1.2";

  src = fetchurl {
    url = "https://github.com/danfis/qshowdiff/archive/v${version}.tar.gz";
    sha256 = "027959xbzvi5c2w9y1x122sr5i26k9mvp43banz2wln6gd860n1a";
  };

  buildInputs = [ qt4 perl pkgconfig ];

  configurePhase = ''
    mkdir -p $out/{bin,man/man1}
    makeFlags="PREFIX=$out"
  '';

  meta = {
    homepage = http://qshowdiff.danfis.cz/;
    description = "Colourful diff viewer";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
