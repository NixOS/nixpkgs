{ stdenv
, gcc8Stdenv
, lib
, fetchFromGitHub
, openssl
, zlib
, cmake
, python2
, python3
, perl
, snappy
, lzo
, which
, catch
, catch2
}:

let
  common = { stdenv, version, sha256 }: stdenv.mkDerivation {
    pname = "arangodb";
    inherit version;

    src = fetchFromGitHub {
      repo = "arangodb";
      owner = "arangodb";
      rev = "v${version}";
      inherit sha256;
    };

    nativeBuildInputs = [
      cmake
      perl
      (if lib.versionAtLeast version "3.9" then python3 else python2)
      which
    ];

    buildInputs = [ openssl zlib snappy lzo ];

    # prevent failing with "cmake-3.13.4/nix-support/setup-hook: line 10: ./3rdParty/rocksdb/RocksDBConfig.cmake.in: No such file or directory"
    dontFixCmake = lib.versionAtLeast version "3.5";
    NIX_CFLAGS_COMPILE = lib.optionalString (lib.versionAtLeast version "3.5") "-Wno-error";
    preConfigure = lib.optionalString (lib.versionAtLeast version "3.5") "patchShebangs utils";

    postPatch = ''
      ${if lib.versionAtLeast version "3.9"
        then "sed -ie 's!/bin/echo!echo!' 3rdParty/V8/gypfiles/*.gypi"
        else "sed -ie 's!/bin/echo!echo!' 3rdParty/V8/v*/gypfiles/*.gypi"}

      # with nixpkgs, it has no sense to check for a version update
      substituteInPlace js/client/client.js --replace "require('@arangodb').checkAvailableVersions();" ""
      substituteInPlace js/server/server.js --replace "require('@arangodb').checkAvailableVersions();" ""

      ${if (lib.versionOlder version "3.4") then ''
        cp ${catch}/include/catch/catch.hpp 3rdParty/catch/catch.hpp
      '' else if (lib.versionOlder version "3.5") then ''
        cp ${catch2}/include/catch2/catch.hpp 3rdParty/catch/catch.hpp
      '' else ''
        (cd 3rdParty/boost/1.69.0 && patch -p1 < ${../../../development/libraries/boost/pthread-stack-min-fix.patch})
      ''}
    '';

    cmakeFlags = [
      # also avoid using builder's /proc/cpuinfo
      "-DHAVE_SSE42=${if stdenv.hostPlatform.sse4_2Support then "ON" else "OFF"}"
      "-DASM_OPTIMIZATIONS=${if stdenv.hostPlatform.sse4_2Support then "ON" else "OFF"}"
    ]
    # do not set GCC's -march=xxx based on builder's /proc/cpuinfo
    # (removed in cc860c333c7f0c1aed9a2179e3e8b926d92b6df4)
    ++ lib.optional (!lib.versionAtLeast version "3.9") "-DUSE_OPTIMIZE_FOR_ARCHITECTURE=OFF";

    meta = with lib; {
      homepage = "https://www.arangodb.com";
      description = "A native multi-model database with flexible data models for documents, graphs, and key-values";
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.flosse maintainers.jsoo1 ];
    };
  };
in
{
  arangodb_3_3 = common {
    stdenv = gcc8Stdenv;
    version = "3.3.24";
    sha256 = "18175789j4y586qvpcsaqxmw7d6vc3s29qm1fja5c7wzimx6ilyp";
  };
  arangodb_3_4 = common {
    stdenv = gcc8Stdenv;
    version = "3.4.8";
    sha256 = "0vm94lf1i1vvs04vy68bkkv9q43rsaf1y3kfs6s3jcrs3ay0h0jn";
  };
  arangodb_3_5 = common {
    inherit stdenv;
    version = "3.5.1";
    sha256 = "1jw3j7vaq3xgkxiqg0bafn4b2169jq7f3y0l7mrpnrpijn77rkrv";
  };
  arangodb_3_9 = common {
    inherit stdenv;
    version = "3.9.3";
    sha256 = "078bs8m045ym0ka0n3n1wvzr8gri09bcs574kdzy8z3rrngvp82m";
  };
}
