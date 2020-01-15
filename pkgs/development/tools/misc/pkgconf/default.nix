{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pkgconf";
  version = "1.6.3";

  src = fetchurl {
    url = "https://distfiles.dereferenced.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "04525vv0y849vvc2pi60g5wd9fjp1wbhra2lniifi82y1ldv7w31";
  };

  meta = with stdenv.lib; {
    description = "Package compiler and linker metadata toolkit";
    homepage = https://git.dereferenced.org/pkgconf/pkgconf;
    platforms = platforms.all;
    license = licenses.isc;
    maintainers = with maintainers; [ zaninime ];
  };
}
