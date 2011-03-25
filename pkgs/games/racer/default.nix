{ fetchurl, stdenv, allegro, libjpeg, makeWrapper }:

stdenv.mkDerivation rec {
  name = "racer-1.1";

  src = fetchurl {
    url = http://hippo.nipax.cz/src/racer-1.1.tar.gz;
    sha256 = "0fll1qkqfcjq87k0jzsilcw701z92lfxn2y5ga1n038772lymxl9";
  };

  buildInputs = [ allegro libjpeg makeWrapper ];

  prePatch = ''
    sed -i s,/usr/local,$out, Makefile src/HGFX.cpp src/STDH.cpp
    sed -i s,/usr/share,$out/share, src/HGFX.cpp src/STDH.cpp
  '';

  patches = [ ./mkdir.patch ];

  meta = {
    description = "Car racing game";
    homepage = http://hippo.nipax.cz/download.en.php;
    license = "GPLv2+";
  };
}
