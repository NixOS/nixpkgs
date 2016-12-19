{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bchunk-1.2.0";

  src = fetchurl {
    url = "http://he.fi/bchunk/${name}.tar.gz";
    sha256 = "0pcbyx3689cbl23dcij497hb3q5f1wmki7cxic5nzldx71g9vp5g";
  };

  preConfigure =
    ''
      substituteInPlace Makefile \
        --replace "-o root -g root" "" \
        --replace "-o bin -g bin" ""
    '';

  makeFlags = "PREFIX=$(out) MAN_DIR=$(out)/share/man";

  preInstall = "mkdir -p $out/bin $out/share/man/man1";

  meta = {
    homepage = http://he.fi/bchunk/;
    description = "A program that converts CD-ROM images in BIN/CUE format into a set of ISO and CDR tracks";
    platforms = stdenv.lib.platforms.linux;
  };
}
