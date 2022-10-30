{
  # gcc 11.2 suggested on 3.10.0.
  # gcc 11.3.0 unsupported yet, investigate gcc support when upgrading
  # See https://github.com/arangodb/arangodb/issues/17454
  gcc10Stdenv
, git
, lib
, fetchFromGitHub
, openssl
, zlib
, cmake
, python3
, perl
, snappy
, lzo
, which
, targetArchitecture ? null
, asmOptimizations ? gcc10Stdenv.targetPlatform.isx86
}:

let
  defaultTargetArchitecture =
    if gcc10Stdenv.targetPlatform.isx86
    then "haswell"
    else "core";

  targetArch =
    if isNull targetArchitecture
    then defaultTargetArchitecture
    else targetArchitecture;
in

gcc10Stdenv.mkDerivation rec {
  pname = "arangodb";
  version = "3.10.0";

  src = fetchFromGitHub {
    repo = "arangodb";
    owner = "arangodb";
    rev = "v${version}";
    sha256 = "0vjdiarfnvpfl4hnqgr7jigxgq3b3zhx88n8liv1zqa1nlvykfrb";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake git perl python3 which ];

  buildInputs = [ openssl zlib snappy lzo ];

  # prevent failing with "cmake-3.13.4/nix-support/setup-hook: line 10: ./3rdParty/rocksdb/RocksDBConfig.cmake.in: No such file or directory"
  dontFixCmake = true;
  NIX_CFLAGS_COMPILE = "-Wno-error";
  preConfigure = "patchShebangs utils";

  postPatch = ''
    sed -ie 's!/bin/echo!echo!' 3rdParty/V8/gypfiles/*.gypi

    # with nixpkgs, it has no sense to check for a version update
    substituteInPlace js/client/client.js --replace "require('@arangodb').checkAvailableVersions();" ""
    substituteInPlace js/server/server.js --replace "require('@arangodb').checkAvailableVersions();" ""
  '';

  cmakeFlags = [
    "-DUSE_MAINTAINER_MODE=OFF"
    "-DUSE_GOOGLE_TESTS=OFF"
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"

    # avoid reading /proc/cpuinfo for feature detection
    "-DTARGET_ARCHITECTURE=${targetArch}"
  ] ++ lib.optionals asmOptimizations [
    "-DASM_OPTIMIZATIONS=ON"
    "-DHAVE_SSE42=${if gcc10Stdenv.targetPlatform.sse4_2Support then "ON" else "OFF"}"
  ];

  meta = with lib; {
    homepage = "https://www.arangodb.com";
    description = "A native multi-model database with flexible data models for documents, graphs, and key-values";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse maintainers.jsoo1 ];
  };
}
