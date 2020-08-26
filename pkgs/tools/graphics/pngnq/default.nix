{ stdenv, fetchurl, pkgconfig, libpng, zlib }:

stdenv.mkDerivation rec {
  name = "pngnq-1.1";

  src = fetchurl {
    url = "mirror://sourceforge/pngnq/${name}.tar.gz";
    sha256 = "1qmnnl846agg55i7h4vmrn11lgb8kg6gvs8byqz34bdkjh5gwiy1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpng zlib ];

  patchPhase = ''
    sed -i '/png.h/a \#include <zlib.h>' src/rwpng.c
  '';

  meta = with stdenv.lib; {
    homepage = "http://pngnq.sourceforge.net/";
    description = "A PNG quantizer";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
