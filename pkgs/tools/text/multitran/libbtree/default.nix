{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "libbtree-0.0.1alpha2";
  src = fetchurl {
    url = mirror://sourceforge/multitran/libbtree-0.0.1alpha2.tar.bz2;
    sha256 = "34a584e45058950337ff9342693b6739b52c3ce17e66440526c4bd6f9575802c";
  };
  patchPhase = ''
    sed -i -e 's@\$(DESTDIR)/usr@'$out'@' src/Makefile;
  '';

  meta = {
    homepage = http://multitran.sourceforge.net/;
    description = "Multitran lib: library for reading Multitran's BTREE database format";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
