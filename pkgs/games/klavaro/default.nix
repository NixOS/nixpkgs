{ stdenv, fetchurl, makeWrapper, pkgconfig, intltool, curl, gtk3 }:

stdenv.mkDerivation rec {
  name = "klavaro-${version}";
  version = "3.02";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${name}.tar.bz2";
    sha256 = "5f77730a8c1c8dfd4443ec8390c7226e3f82537df0882cd1222b140f0d0fcd6c";
  };

  buildInputs = [ makeWrapper pkgconfig intltool curl gtk3 ];

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
