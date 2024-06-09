{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake
, valgrind
}:

stdenv.mkDerivation rec {
  pname = "lz4";
  version = "1.9.4";

  src = fetchFromGitHub {
    sha256 = "sha256-YiMCD3vvrG+oxBUghSrCmP2LAfAGZrEaKz0YoaQJhpI=";
    rev = "v${version}";
    repo = pname;
    owner = pname;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optional finalAttrs.doCheck valgrind;

  # TODO(@Ericson2314): Separate binaries and libraries
  outputs = [ "bin" "out" "dev" ];

  patches = [
    (fetchpatch { # https://github.com/lz4/lz4/pull/1162
      name = "build-shared-no.patch";
      url = "https://github.com/lz4/lz4/commit/851ef4b23c7cbf4ceb2ba1099666a8b5ec4fa195.patch";
      sha256 = "sha256-P+/uz3m7EAmHgXF/1Vncc0uKKxNVq6HNIsElx0rGxpw=";
    })
  ];

  cmakeDir = "../build/cmake";
  cmakeBuildDir = "build-dist";

  doCheck = false; # tests take a very long time
  checkTarget = "test";

  meta = with lib; {
    description = "Extremely fast compression algorithm";
    longDescription = ''
      Very fast lossless compression algorithm, providing compression speed
      at 400 MB/s per core, with near-linear scalability for multi-threaded
      applications. It also features an extremely fast decoder, with speed in
      multiple GB/s per core, typically reaching RAM speed limits on
      multi-core systems.
    '';
    homepage = "https://lz4.github.io/lz4/";
    license = with licenses; [ bsd2 gpl2Plus ];
    platforms = platforms.all;
  };
}
