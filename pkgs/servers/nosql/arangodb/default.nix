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
    NIX_CFLAGS_COMPILE = lib.optionals      (lib.versionAtLeast version "3.5") [ "-Wno-error" ];
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
    { "westmere"       = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      "sandybridge"    = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      "ivybridge"      = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      "haswell"        = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      "broadwell"      = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      "skylake"        = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
      "skylake-avx512" = [ "-DHAVE_SSE42=ON" "-DASM_OPTIMIZATIONS=ON" ];
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
  arangodb_3_2 = common { version = "3.2.18";     sha256 = "05mfrx1g6dh1bzzqs23nvk0rg3v8y2dhdam4lym55pzlhqa7lf0x"; };
  arangodb_3_3 = common { version = "3.3.23.1";   sha256 = "0bnbiispids7jcgrgcmanf9jqgvk0vaflrvgalz587jwr2zf21k8"; };
  arangodb_3_4 = common { version = "3.4.7";      sha256 = "1wr2xvi5lnl6f2ryyxdwn4wnfiaz0rrf58ja1k19m7b6w3264iim"; };
  arangodb_3_5 = common { version = "3.5.0-rc.7"; sha256 = "1sdmbmyml9d3ia3706bv5901qqmh4sxk7js5b9hyfjqpcib10d1k"; };
}
