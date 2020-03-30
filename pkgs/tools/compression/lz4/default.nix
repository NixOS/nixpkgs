{ stdenv, fetchFromGitHub, valgrind, fetchpatch
, enableStatic ? false, enableShared ? true
}:

stdenv.mkDerivation rec {
  pname = "lz4";
  version = "1.9.2";

  src = fetchFromGitHub {
    sha256 = "0lpaypmk70ag2ks3kf2dl4ac3ba40n5kc1ainkp9wfjawz76mh61";
    rev = "v${version}";
    repo = pname;
    owner = pname;
  };

  # TODO(@Ericson2314): Separate binaries and libraries
  outputs = [ "out" "dev" ];

  buildInputs = stdenv.lib.optional doCheck valgrind;

  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=$(out)"
    "INCLUDEDIR=$(dev)/include"
    # TODO do this instead
    #"BUILD_STATIC=${if enableStatic then "yes" else "no"}"
    #"BUILD_SHARED=${if enableShared then "yes" else "no"}"
    #"WINDRES:=${stdenv.cc.bintools.targetPrefix}windres"
  ]
    # TODO delete and do above
    ++ stdenv.lib.optional (enableStatic) "BUILD_STATIC=yes"
    ++ stdenv.lib.optional (!enableShared) "BUILD_SHARED=no"
    ++ stdenv.lib.optional stdenv.hostPlatform.isMinGW "WINDRES:=${stdenv.cc.bintools.targetPrefix}windres"
    # TODO make full dictionary
    ++ stdenv.lib.optional stdenv.hostPlatform.isMinGW "TARGET_OS=MINGW"
    ;

  doCheck = false; # tests take a very long time
  checkTarget = "test";

  # TODO(@Ericson2314): Make resusable setup hook for this issue on Windows.
  postInstall =
    stdenv.lib.optionalString stdenv.hostPlatform.isWindows ''
      mv $out/bin/*.dll $out/lib
      ln -s $out/lib/*.dll
    ''
    # TODO remove
    + stdenv.lib.optionalString (!enableStatic) "rm $out/lib/*.a";

  meta = with stdenv.lib; {
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
