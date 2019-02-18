{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pkgconf-1.6.0";

  src = fetchurl {
    url = "https://distfiles.dereferenced.org/pkgconf/${name}.tar.xz";
    sha256 = "1rgcw7lbmxv45y4ybnlh1wzhd1d15d2616499ajjnrvnnnms6db1";
  };

  meta = with stdenv.lib; {
    description = "Package compiler and linker metadata toolkit";
    homepage = https://git.dereferenced.org/pkgconf/pkgconf;
    platforms = platforms.all;
    license = licenses.isc;
    maintainers = with maintainers; [ zaninime ];
  };
}
