{ stdenv, lib, fetchFromGitHub, openssl, zlib, cmake, python3, perl, snappy, lzo, which, gcc10Stdenv}:

let
  common = { version, sha256 }: gcc10Stdenv.mkDerivation {
    pname = "arangodb";
    inherit version;

    src = fetchFromGitHub {
      repo = "arangodb";
      owner = "arangodb";
      rev = "v${version}";
      inherit sha256;
    };

    nativeBuildInputs = [ cmake python3 perl which ];
    buildInputs = [ openssl zlib snappy lzo];

    # prevent failing with "cmake-3.13.4/nix-support/setup-hook: line 10: ./3rdParty/rocksdb/RocksDBConfig.cmake.in: No such file or directory"
    dontFixCmake       = true;
    NIX_CFLAGS_COMPILE = "-Wno-error -Wno-extra -Wno-suggest-override -Wno-missing-attributes";
    preConfigure       = "patchShebangs utils";

    enableParallelBuilding = true;

    postPatch = ''
      sed -ie 's!/bin/echo!echo!' 3rdParty/V8/gypfiles/*.gypi
      # with nixpkgs, it has no sense to check for a version update
      substituteInPlace js/client/client.js --replace "require('@arangodb').checkAvailableVersions();" ""
      substituteInPlace js/server/server.js --replace "require('@arangodb').checkAvailableVersions();" ""

    '';
    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
      "-DUSE_MAINTAINER_MODE=off"
      "-DUSE_GOOGLE_TESTS=off"
      "-DUSE_OPTIMIZE_FOR_ARCHITECTURE=on"
      # also avoid using builder's /proc/cpuinfo
      "-DHAVE_SSE42=${if stdenv.hostPlatform.sse4_2Support then "ON" else "OFF"}"
      "-DASM_OPTIMIZATIONS=${if stdenv.hostPlatform.sse4_2Support then "ON" else "OFF"}"
    ];

    meta = with lib; {
      homepage = "https://www.arangodb.com";
      description = "A native multi-model database with flexible data models for documents, graphs, and key-values";
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.flosse ];
    };
  };
in
  arangodb_9_3 {
    version = "3.9.3";
    sha256 = "078bs8m045ym0ka0n3n1wvzr8gri09bcs574kdzy8z3rrngvp82m";
  }
