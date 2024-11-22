{lib, stdenv, fetchurl, libmtsupport, libfacet, libbtree, libmtquery, help2man} :

stdenv.mkDerivation rec {
  pname = "mt-utils";
  version = "0.0.1alpha3";

  src = fetchurl {
      url = "mirror://sourceforge/multitran/mt-utils-${version}.tar.bz2";
      sha256 = "e407702c90c5272882386914e1eeca5f6c5039393af9a44538536b94867b0a0e";
  };

  buildInputs = [ libmtsupport libfacet libbtree libmtquery help2man ];

  patchPhase = ''
    sed -i -e 's@\$(DESTDIR)/usr@'$out'@' \
      -e 's@/usr/include/mt/support@${libmtsupport}/include/mt/support@' \
      -e 's@/usr/include/btree@${libbtree}/include/btree@' \
      -e 's@/usr/include/facet@${libfacet}/include/facet@' \
      -e 's@/usr/include/mt/query@${libmtquery}/include/mt/query@' \
      -e 's@-lmtquery@-lmtquery -lmtsupport -lfacet@' \
      src/Makefile;
    # Fixing multibyte locale output
    sed -i -e 's@message.length()@message.length()*5@' \
      src/converter.cc;
  '';

  meta = {
    homepage = "https://multitran.sourceforge.net/";
    description = "Multitran: simple command line utilities for dictionary maintenance";
    mainProgram = "mtquery";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
}
