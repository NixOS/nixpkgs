{ stdenv, fetchFromGitHub, valgrind }:

let version = "128"; in
stdenv.mkDerivation rec {
  name = "lz4-${version}";

  src = fetchFromGitHub {
    sha256 = "00jrnic2jddj81av8jjipf4rdkx6x6cdf8zpsz3mp5kbmqzd0h9a";
    rev = "r${version}";
    repo = "lz4";
    owner = "Cyan4973";
  };

  buildInputs = stdenv.lib.optional doCheck valgrind;

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
