{
  lib,
  stdenv,
  fetchurl,
  erlang,
  icu,
  openssl,
  python3,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "couchdb";
  version = "3.5.1";

  src = fetchurl {
    url = "mirror://apache/couchdb/source/${version}/apache-${pname}-${version}.tar.gz";
    hash = "sha256-wizzHW2Ro/WqBPDK1JO6vccjITSUy15hcKUH01nFATY=";
  };

  postPatch = ''
    patchShebangs bin/rebar
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # LTO with Clang produces LLVM bitcode, which causes linking to fail quietly.
    # (There are warnings, but no hard errors, and it produces an empty dylib.)
    substituteInPlace src/jiffy/rebar.config.script --replace '"-flto"' '""'
  '';

  nativeBuildInputs = [
    erlang
  ];

  buildInputs = [
    icu
    openssl
    (python3.withPackages (ps: with ps; [ requests ]))
  ];

  dontAddPrefix = "True";

  configureFlags = [
    "--js-engine=quickjs"
    "--disable-spidermonkey"
  ];

  buildFlags = [
    "release"
  ];

  env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=implicit-function-declaration"
    ]
  );

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r rel/couchdb/* $out
    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) couchdb;
  };

  meta = {
    description = "Database that uses JSON for documents, JavaScript for MapReduce queries, and regular HTTP for an API";
    homepage = "https://couchdb.apache.org";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
