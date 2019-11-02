{ stdenv, fetchFromGitHub, valgrind, fetchpatch
, enableStatic ? false, enableShared ? true
}:

stdenv.mkDerivation rec {
  pname = "lz4";
  version = "1.9.1";

  src = fetchFromGitHub {
    sha256 = "1l1caxrik1hqs40vj3bpv1pikw6b74cfazv5c0v6g48zpcbmshl0";
    rev = "v${version}";
    repo = pname;
    owner = pname;
  };

  patches = [
    # Fix detection of Darwin
    (fetchpatch {
      url = "https://github.com/lz4/lz4/commit/024216ef7394b6411eeaa5b52d0cec9953a44249.patch";
      sha256 = "0j0j2pr6pkplxf083hlwl5q4cfp86q3wd8mc64bcfcr7ysc5pzl3";
    })
  ];

  outputs = [ "out" "dev" ];

  buildInputs = stdenv.lib.optional doCheck valgrind;

  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=$(out)"
    "INCLUDEDIR=$(dev)/include"
    # TODO do this instead
    #"BUILD_STATIC=${if enableStatic then "yes" else "no"}"
    #"BUILD_SHARED=${if enableShared then "yes" else "no"}"
  ]
    # TODO delete and do above
    ++ stdenv.lib.optional (enableStatic) "BUILD_STATIC=yes"
    ++ stdenv.lib.optional (!enableShared) "BUILD_SHARED=no"
    ;

  doCheck = false; # tests take a very long time
  checkTarget = "test";

  # TODO remove
  postInstall = stdenv.lib.optionalString (!enableStatic) "rm $out/lib/*.a";

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
