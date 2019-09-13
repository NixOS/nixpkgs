{ stdenv, fetchurl, makeWrapper, pkgconfig, intltool, curl, gtk3 }:

stdenv.mkDerivation rec {
  pname = "klavaro";
  version = "3.08";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${pname}-${version}.tar.bz2";
    sha256 = "0qmvr6d8wshwp0xvk5wbig4vlzxzcxrakhyhd32v8v3s18nhqsrc";
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
