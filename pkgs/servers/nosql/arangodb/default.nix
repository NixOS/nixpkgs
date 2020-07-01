{ stdenv, lib, fetchFromGitHub, openssl, zlib, cmake, python2, perl, snappy, lzo, which }:

let
  common = { version, sha256 }: stdenv.mkDerivation {
    pname = "arangodb";
    inherit version;

    src = fetchFromGitHub {
      repo = "arangodb";
      owner = "arangodb";
      rev = "v${version}";
      inherit sha256;
    };

    nativeBuildInputs = [ cmake python2 perl which ];
    buildInputs = [ openssl zlib snappy lzo ];

    # prevent failing with "cmake-3.13.4/nix-support/setup-hook: line 10: ./3rdParty/rocksdb/RocksDBConfig.cmake.in: No such file or directory"
    dontFixCmake       =                     lib.versionAtLeast version "3.5";
    NIX_CFLAGS_COMPILE = lib.optionalString (lib.versionAtLeast version "3.5") "-Wno-error";
    preConfigure       = lib.optionalString (lib.versionAtLeast version "3.5") "patchShebangs utils";

    postPatch = ''
      sed -ie 's!/bin/echo!echo!' 3rdParty/V8/v*/gypfiles/*.gypi

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
      homepage = "https://www.arangodb.com";
      description = "A native multi-model database with flexible data models for documents, graphs, and key-values";
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.flosse ];
    };
  };
in {
  arangodb_3_3 = common {
    version = "3.3.24";
    sha256 = "18175789j4y586qvpcsaqxmw7d6vc3s29qm1fja5c7wzimx6ilyp";
  };
  arangodb_3_4 = common {
    version = "3.4.8";
    sha256 = "0vm94lf1i1vvs04vy68bkkv9q43rsaf1y3kfs6s3jcrs3ay0h0jn";
  };
  arangodb_3_5 = common {
    version = "3.5.1";
    sha256 = "1jw3j7vaq3xgkxiqg0bafn4b2169jq7f3y0l7mrpnrpijn77rkrv";
  };
}
