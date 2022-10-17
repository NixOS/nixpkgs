{ lib, stdenv, fetchFromGitHub, openssl, curl, postgresql, yajl }:

stdenv.mkDerivation rec {
  pname = "kore";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "jorisvink";
    repo = pname;
    rev = version;
    sha256 = "sha256-p0M2P02xwww5EnT28VnEtj5b+/jkPW3YkJMuK79vp4k=";
  };

  buildInputs = [ openssl curl postgresql yajl ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ACME=1"
    "CURL=1"
    "TASKS=1"
    "PGSQL=1"
    "JSONRPC=1"
    "DEBUG=1"
  ];

  preBuild = ''
    make platform.h
  '';

  # added to fix build w/gcc7 and clang5
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=pointer-compare"
    + lib.optionalString stdenv.cc.isClang " -Wno-error=unknown-warning-option";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "An easy to use web application framework for C";
    homepage = "https://kore.io";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ johnmh ];
  };
}
