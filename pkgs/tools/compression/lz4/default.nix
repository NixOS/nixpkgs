{ lib, stdenv, fetchFromGitHub, fetchpatch, valgrind
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !stdenv.hostPlatform.isStatic
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

  patches = [
    (fetchpatch { # https://github.com/lz4/lz4/pull/1162
      name = "build-shared-no.patch";
      url = "https://github.com/lz4/lz4/commit/851ef4b23c7cbf4ceb2ba1099666a8b5ec4fa195.patch";
      sha256 = "sha256-P+/uz3m7EAmHgXF/1Vncc0uKKxNVq6HNIsElx0rGxpw=";
    })
  ];

  # TODO(@Ericson2314): Separate binaries and libraries
  outputs = [ "bin" "out" "dev" ];

  buildInputs = lib.optional doCheck valgrind;

  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=$(out)"
    "INCLUDEDIR=$(dev)/include"
    "BUILD_STATIC=${if enableStatic then "yes" else "no"}"
    "BUILD_SHARED=${if enableShared then "yes" else "no"}"
    "WINDRES:=${stdenv.cc.bintools.targetPrefix}windres"
  ]
    # TODO make full dictionary
    ++ lib.optional stdenv.hostPlatform.isMinGW "TARGET_OS=MINGW"
    ++ lib.optional stdenv.hostPlatform.isLinux "TARGET_OS=Linux"
    ;

  doCheck = false; # tests take a very long time
  checkTarget = "test";

  # TODO(@Ericson2314): Make resusable setup hook for this issue on Windows.
  postInstall =
    lib.optionalString stdenv.hostPlatform.isWindows ''
      mv $out/bin/*.dll $out/lib
      ln -s $out/lib/*.dll
    ''
    + ''
      moveToOutput bin "$bin"
    '';

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
