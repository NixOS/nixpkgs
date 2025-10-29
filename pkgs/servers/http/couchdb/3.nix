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
  version = "3.5.0";

  src = fetchurl {
    url = "mirror://apache/couchdb/source/${version}/apache-${pname}-${version}.tar.gz";
    hash = "sha256-api5CpqYC77yw1tJlqjnGi8a5SJ1RshfBMQ2EBvfeL8=";
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

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r rel/couchdb/* $out
    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) couchdb;
  };

  meta = with lib; {
    description = "Database that uses JSON for documents, JavaScript for MapReduce queries, and regular HTTP for an API";
    homepage = "https://couchdb.apache.org";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ lostnet ];
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
