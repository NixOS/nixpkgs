{ stdenv, fetchurl, makeWrapper, pkgconfig, intltool, curl, gtk3 }:

stdenv.mkDerivation rec {
  name = "klavaro-${version}";
  version = "3.05";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${name}.tar.bz2";
    sha256 = "046xc7is1jz5azkwrb7i9wdqkz8hdm68ga02g6whmi53130wd0py";
  };

  nativeBuildInputs = [ intltool makeWrapper pkgconfig ];
  buildInputs = [ curl gtk3 ];

  postInstall = ''
    wrapProgram $out/bin/klavaro \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = {
    description = "Just another free touch typing tutor program";
    homepage = http://klavaro.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.mimadrid];
  };
}
