{ stdenv, gcc8Stdenv, lib, fetchFromGitHub, openssl_1_1, zlib, cmake, python2, python3, perl, snappy, lzo, which }:

let
  common = { version, sha256, stdenv, python }: stdenv.mkDerivation {
    pname = "arangodb";
    inherit version;

    src = fetchFromGitHub {
      repo = "arangodb";
      owner = "arangodb";
      rev = "v${version}";
      inherit sha256;
    };

    nativeBuildInputs = [ cmake python perl which ];
    buildInputs = [ openssl_1_1 zlib snappy lzo ];

    # prevent failing with "cmake-3.13.4/nix-support/setup-hook: line 10: ./3rdParty/rocksdb/RocksDBConfig.cmake.in: No such file or directory"
    dontFixCmake       = true;
    NIX_CFLAGS_COMPILE = "-Wno-error";
    preConfigure       = "patchShebangs utils";

    postPatch = ''
      find 3rdParty/V8  -type f  -name '*.gypi'  -exec sed -ie 's!/bin/echo!echo!' {} \;

      # with nixpkgs, it has no sense to check for a version update
      substituteInPlace js/client/client.js --replace "require('@arangodb').checkAvailableVersions();" ""
      substituteInPlace js/server/server.js --replace "require('@arangodb').checkAvailableVersions();" ""
    '';

    cmakeFlags = [
      # do not set GCC's -march=xxx based on builder's /proc/cpuinfo
      "-DUSE_OPTIMIZE_FOR_ARCHITECTURE=OFF"
      # also avoid using builder's /proc/cpuinfo
    ] ++
    { westmere       = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      sandybridge    = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      ivybridge      = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      haswell        = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      broadwell      = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      skylake        = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      skylake-avx512 = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
    }.${stdenv.hostPlatform.platform.gcc.arch or ""} or [ "-DHAVE_SSE42=OFF" "-DASM_OPTIMIZATIONS=OFF" ];

    enableParallelBuilding = true;

    meta = with lib; {
      homepage = https://www.arangodb.com;
      description = "A native multi-model database with flexible data models for documents, graphs, and key-values";
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.flosse ];
    };
  };
in {
  arangodb_3_3 = common {
    version = "3.3.25";
    sha256 = "0xpmksnvcwmv6dd9yig3ywbx12d1lxyp2wg68cg3rjlvsycrvm9n";
    stdenv = gcc8Stdenv;
    python = python2;
  };
  arangodb_3_4 = common {
    version = "3.4.8";
    sha256 = "0vm94lf1i1vvs04vy68bkkv9q43rsaf1y3kfs6s3jcrs3ay0h0jn";
    stdenv = gcc8Stdenv;
    python = python2;
  };
  arangodb_3_5 = common {
    version = "3.5.4";
    sha256 = "1dcc4s415rararw5lw829p9c6qkj2nj5q0sb72rdyjm61l2q1zlj";
    stdenv = stdenv;
    python = python2;
  };
  arangodb_3_6 = common {
    version = "3.6.2";
    sha256 = "1wvx498jp3gi9r2zn6g8b4sc7i3arr125y0nw25w8gks8i8n4j48";
    stdenv = stdenv;
    python = python2;
  };
  arangodb_3_7 = common {
    version = "3.7.0-alpha.1";
    sha256 = "0a7vk8ffw6scz8014lz6v777fzyi4m0ghfqzbicfdy6acmpf9sql";
    stdenv = stdenv;
    python = python3;
  };
}
