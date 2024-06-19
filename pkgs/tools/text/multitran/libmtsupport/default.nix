{lib, stdenv, fetchurl} :

stdenv.mkDerivation rec {
  pname = "libmtsupport";
  version = "0.0.1alpha2";

  src = fetchurl {
    url = "mirror://sourceforge/multitran/libmtsupport-${version}.tar.bz2";
    sha256 = "481f0f1ec15d7274f1e4eb93e7d060df10a181efd037eeff5e8056d283a9298b";
  };
  patchPhase = ''
    sed -i -e 's@\$(DESTDIR)/usr@'$out'@' src/Makefile;
  '';

  meta = {
    homepage = "https://multitran.sourceforge.net/";
    description = "Multitran lib: basic useful functions";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
