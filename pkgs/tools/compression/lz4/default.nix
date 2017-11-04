{ stdenv, fetchFromGitHub, valgrind }:

stdenv.mkDerivation rec {
  name = "lz4-${version}";
  version = "131";

  src = fetchFromGitHub {
    sha256 = "1bhvcq8fxxsqnpg5qa6k3nsyhq0nl0iarh08sqzclww27hlpyay2";
    rev = "r${version}";
    repo = "lz4";
    owner = "Cyan4973";
  };

  outputs = [ "out" "dev" ];

  buildInputs = stdenv.lib.optional doCheck valgrind;

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" "INCLUDEDIR=$(dev)/include" ];

  doCheck = false; # tests take a very long time
  checkTarget = "test";

  patches = [ ./install-on-freebsd.patch ] ;

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
    maintainers = with maintainers; [ nckx ];
  };
}
