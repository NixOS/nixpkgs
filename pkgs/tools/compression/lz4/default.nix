{ lib, stdenv, fetchFromGitHub, valgrind
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
