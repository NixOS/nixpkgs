{ stdenv, fetchFromGitHub, valgrind }:

stdenv.mkDerivation rec {
  name = "lz4-${version}";
  version = "1.8.3";

  src = fetchFromGitHub {
    sha256 = "0lq00yi7alr9aip6dw0flykzi8yv7z43aay177n86spn9qms7s3g";
    rev = "v${version}";
    repo = "lz4";
    owner = "lz4";
  };

  outputs = [ "out" "dev" ];

  buildInputs = stdenv.lib.optional doCheck valgrind;

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" "INCLUDEDIR=$(dev)/include" ];

  doCheck = false; # tests take a very long time
  checkTarget = "test";

  postInstall = "rm $out/lib/*.a";

  meta = with stdenv.lib; {
    description = "Extremely fast compression algorithm";
    longDescription = ''
      Very fast lossless compression algorithm, providing compression speed
      at 400 MB/s per core, with near-linear scalability for multi-threaded
      applications. It also features an extremely fast decoder, with speed in
      multiple GB/s per core, typically reaching RAM speed limits on
      multi-core systems.
    '';
    homepage = https://lz4.github.io/lz4/;
    license = with licenses; [ bsd2 gpl2Plus ];
    platforms = platforms.unix;
  };
}
