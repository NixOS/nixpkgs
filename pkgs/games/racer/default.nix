{ fetchurl, stdenv, allegro, libjpeg, makeWrapper }:

stdenv.mkDerivation rec {
  name = "racer-1.1";

  src = if stdenv.system == "i686-linux" then fetchurl {
    url = http://hippo.nipax.cz/src/racer-1.1.tar.gz;
    sha256 = "0fll1qkqfcjq87k0jzsilcw701z92lfxn2y5ga1n038772lymxl9";
  } else if stdenv.system == "x86_64-linux" then fetchurl {
    url = http://hippo.nipax.cz/src/racer-1.1.64.tar.gz;
    sha256 = "0rjy3gmlhwfkb9zs58j0mc0dar0livwpbc19r6zw5r2k6r7xdan0";
  } else
    throw "System not supported";


  buildInputs = [ allegro libjpeg makeWrapper ];

  prePatch = ''
    sed -i s,/usr/local,$out, Makefile src/HGFX.cpp src/STDH.cpp
    sed -i s,/usr/share,$out/share, src/HGFX.cpp src/STDH.cpp
  '';

  patches = [ ./mkdir.patch ];

  meta = {
    description = "Car racing game";
    homepage = http://hippo.nipax.cz/download.en.php;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
