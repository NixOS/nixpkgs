{ stdenv, fetchurl, makeWrapper, pkgconfig, intltool, curl, gtk3 }:

stdenv.mkDerivation rec {
  name = "klavaro-3.01";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${name}.tar.bz2";
    sha256 = "11ay04lg362bh2di6y5r9g58bgmgbpwwnrbsa7bda4wiq8idawgd";
  };

  buildInputs = [ makeWrapper pkgconfig intltool curl gtk3 ];

  postInstall = ''
    wrapProgram $out/bin/klavaro \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = {
    description = "Just another free touch typing tutor program";
    homepage = http://klavaro.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
