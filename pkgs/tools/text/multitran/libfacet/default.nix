{ stdenv, fetchurl, libmtsupport }:

stdenv.mkDerivation {
  name = "libfacet-0.0.1alpha2";
  
  src = fetchurl {
    url = mirror://sourceforge/multitran/libfacet-0.0.1alpha2.tar.bz2;
    sha256 = "dc53351c4035a3c27dc6c1d0410e808346fbc107e7e7c112ec65c59d0df7a144";
  };

  buildInputs = [ libmtsupport ];

  patchPhase = ''
    sed -i -e 's@\$(DESTDIR)/usr@'$out'@' \
      -e 's@/usr/include/mt/support@${libmtsupport}/include/mt/support@' \
      src/Makefile;
  '';

  meta = {
    homepage = http://multitran.sourceforge.net/;
    description = "Multitran lib: enchanced locale facets";
    license = stdenv.lib.licenses.gpl2;
  };
}
