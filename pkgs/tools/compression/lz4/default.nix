{ stdenv, fetchurl, valgrind }:

stdenv.mkDerivation rec {
  # The r127 source still calls itself r126 everywhere, but I'm not going to
  # patch over such silly cosmetic oversights in an official release. -- nckx
  version = "127";
  name = "lz4-${version}";

  src = fetchurl {
    url = "https://github.com/Cyan4973/lz4/archive/r${version}.tar.gz";
    sha256 = "0hvbbr07j4hfix4dn4xw4fsmkr5s02bj596fn0i15d1i49xby2aj";
  };

  # valgrind is required only by `make test`
  buildInputs = [ valgrind ];

  enableParallelBuilding = true;

  makeFlags = "PREFIX=$(out)";

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Extremely fast compression algorithm";
    longDescription = ''
      Very fast lossless compression algorithm, providing compression speed
      at 400 MB/s per core, with near-linear scalability for multi-threaded
      applications. It also features an extremely fast decoder, with speed in
      multiple GB/s per core, typically reaching RAM speed limits on
      multi-core systems.
    '';
    homepage = https://code.google.com/p/lz4/;
    license = with licenses; [ bsd2 gpl2Plus ];
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
