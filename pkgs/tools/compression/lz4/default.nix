{ lib, stdenv, fetchFromGitHub, valgrind, fetchpatch
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "lz4";
  version = "1.9.3";

  src = fetchFromGitHub {
    sha256 = "1w02kazh1fps3sji2sn89fz862j1199c5ajrqcgl1bnlxj09kcbz";
    rev = "v${version}";
    repo = pname;
    owner = pname;
  };

  patches = [
    (fetchpatch { # https://github.com/lz4/lz4/pull/972
      name = "CVE-2021-3520.patch";
      url = "https://github.com/lz4/lz4/commit/8301a21773ef61656225e264f4f06ae14462bca7.patch";
      sha256 = "0r1cwpqdkdc8im0pf2r5jp7mwwn69xcw405rrk7rc0mpjcp5ydfk";
    })
    (fetchpatch { # https://github.com/lz4/lz4/pull/973
      name = "avoid-null-pointer-dereference.patch";
      url = "https://github.com/lz4/lz4/commit/29a6a1f4941e7243241fe00d6c13b749fd6b60c2.patch";
      sha256 = "0v5yl5hd3qrfm3xm7m06j4b21qwllb4cqkjn2az7x1vnzqgpf8y7";
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
