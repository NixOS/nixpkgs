{stdenv, fetchurl, help2man}:

stdenv.mkDerivation rec {
  version = "1.4.2.439";
  name = "fatsort-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/fatsort/${name}.tar.xz";
    sha256 = "1q51qq69854kr12knhyqjv7skj95qld6j04pv5v3xvxs0y9zkg5x";
  };

  patches = [ ./fatsort-Makefiles.patch ];

  buildInputs = [ help2man ];

  meta = with stdenv.lib; {
    homepage = http://fatsort.sourceforge.net/;
    description = "Sorts FAT partition table, for devices that don't do sorting of files";
    maintainers = [ maintainers.kovirobi ];
    license = licenses.gpl2;
    inherit version;
    platforms = platforms.linux;
  };
}
