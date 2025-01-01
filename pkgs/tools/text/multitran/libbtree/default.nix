{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libbtree";
  version = "0.0.1alpha2";

  src = fetchurl {
    url = "mirror://sourceforge/multitran/libbtree-${version}.tar.bz2";
    sha256 = "34a584e45058950337ff9342693b6739b52c3ce17e66440526c4bd6f9575802c";
  };
  patchPhase = ''
    sed -i -e 's@\$(DESTDIR)/usr@'$out'@' src/Makefile;
  '';

  meta = {
    homepage = "https://multitran.sourceforge.net/";
    description = "Multitran lib: library for reading Multitran's BTREE database format";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
