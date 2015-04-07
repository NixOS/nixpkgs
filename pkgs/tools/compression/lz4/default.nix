{ stdenv, fetchurl, valgrind }:

stdenv.mkDerivation rec {
  version = "128";
  name = "lz4-${version}";

  src = fetchurl {
    url = "https://github.com/Cyan4973/lz4/archive/r${version}.tar.gz";
    sha256 = "1lf7a0gqm2q7p1qs28lmajmls3pwfk2p0w3hljjlmshbkndaj26b";
  };

  # valgrind is required only by `make test`
  buildInputs = [ valgrind ];

  enableParallelBuilding = true;

  makeFlags = "PREFIX=$(out)";

  doCheck = true;
  checkTarget = "test";
  checkFlags = "-j1"; # required since version 128

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
