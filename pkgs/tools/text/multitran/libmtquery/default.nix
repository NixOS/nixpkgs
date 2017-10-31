{stdenv, fetchurl, libmtsupport, libfacet, libbtree, multitrandata } :

stdenv.mkDerivation {
  name = "libmtquery-0.0.1alpha3";
  src = fetchurl {
    url = mirror://sourceforge/multitran/libmtquery-0.0.1alpha3.tar.bz2;
    sha256 = "e24c7c15772445f1b14871928d84dd03cf93bd88f9d2b2ed1bf0257c2cf2b15e";
  };

  buildInputs = [ libmtsupport libfacet libbtree multitrandata ];

  patchPhase = ''
    sed -i -e 's@\$(DESTDIR)/usr@'$out'@' \
      -e 's@/usr/include/mt/support@${libmtsupport}/include/mt/support@' \
      -e 's@/usr/include/btree@${libbtree}/include/btree@' \
      -e 's@/usr/include/facet@${libfacet}/include/facet@' \
      src/Makefile testsuite/Makefile;
    sed -i -e 's@/usr/share/multitran@${multitrandata}/share/multitran@' src/config.cc
  '';

  meta = {
    homepage = http://multitran.sourceforge.net/;
    description = "Multitran lib: main engine to query translations";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
