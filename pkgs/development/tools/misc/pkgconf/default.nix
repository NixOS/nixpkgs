{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pkgconf";
  version = "1.6.1";

  src = fetchurl {
    url = "https://distfiles.dereferenced.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1310va0nm8iyb4ghgz9qlx7qb00iha1523hq1zbgj0c98cwfxf92";
  };

  meta = with stdenv.lib; {
    description = "Package compiler and linker metadata toolkit";
    homepage = https://git.dereferenced.org/pkgconf/pkgconf;
    platforms = platforms.all;
    license = licenses.isc;
    maintainers = with maintainers; [ zaninime ];
  };
}
