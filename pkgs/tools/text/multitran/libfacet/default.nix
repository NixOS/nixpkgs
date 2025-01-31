{ lib, stdenv, fetchurl, libmtsupport }:

stdenv.mkDerivation rec {
  pname = "libfacet";
  version = "0.0.1alpha2";

  src = fetchurl {
    url = "mirror://sourceforge/multitran/libfacet-${version}.tar.bz2";
    sha256 = "dc53351c4035a3c27dc6c1d0410e808346fbc107e7e7c112ec65c59d0df7a144";
  };

  buildInputs = [ libmtsupport ];

  patchPhase = ''
    sed -i -e 's@\$(DESTDIR)/usr@'$out'@' \
      -e 's@/usr/include/mt/support@${libmtsupport}/include/mt/support@' \
      src/Makefile;
  '';

  meta = {
    homepage = "https://multitran.sourceforge.net/";
    description = "Multitran lib: enchanced locale facets";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
