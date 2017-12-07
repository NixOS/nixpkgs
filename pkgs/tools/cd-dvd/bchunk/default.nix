{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bchunk-1.2.0";

  src = fetchurl {
    url = "http://he.fi/bchunk/${name}.tar.gz";
    sha256 = "0pcbyx3689cbl23dcij497hb3q5f1wmki7cxic5nzldx71g9vp5g";
  };

  patches = [ ./CVE-2017-15953.patch ./CVE-2017-15955.patch ];

  installPhase = ''
    install -Dt $out/bin bchunk
    install -Dt $out/share/man/man1 bchunk.1    
  '';

  meta = with stdenv.lib; {
    homepage = http://he.fi/bchunk/;
    description = "A program that converts CD images in BIN/CUE format into a set of ISO and CDR tracks";
    platforms = platforms.unix;
  };
}
