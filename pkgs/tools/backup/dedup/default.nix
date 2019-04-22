{ stdenv, fetchurl, lz4, snappy, openmp }:

stdenv.mkDerivation rec {
  pname = "dedup";
  version = "1.0";

  src = fetchurl {
    url = "https://dl.2f30.org/releases/${pname}-${version}.tar.gz";
    sha256 = "0wd4cnzhqk8l7byp1y16slma6r3i1qglwicwmxirhwdy1m7j5ijy";
  };

  makeFlags = [
    "CC:=$(CC)"
    "PREFIX=${placeholder "out"}"
    "MANPREFIX=${placeholder "out"}/share/man"
    # These are likely wrong on some platforms, please report!
    "OPENMPCFLAGS=-fopenmp"
    "OPENMPLDLIBS=-lgomp"
  ];

  buildInputs = [ lz4 snappy openmp ];

  meta = with stdenv.lib; {
    description = "data deduplication program";
    homepage = https://git.2f30.org/dedup/file/README.html;
    license = with licenses; [ bsd0 isc ];
    maintainers = with maintainers; [ dtzWill ];
  };
}
