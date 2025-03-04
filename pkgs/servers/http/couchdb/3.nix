{ lib
, stdenv
, fetchurl
, erlang
, icu
, openssl
, spidermonkey_91
, python3
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "couchdb";
  version = "3.4.2";

  src = fetchurl {
    url = "mirror://apache/couchdb/source/${version}/apache-${pname}-${version}.tar.gz";
    hash = "sha256-0n/yoTNWAAKWqYq4hMrz0XWSfPIXJ5Y/+Q+rOnR1RM8=";
  };

  postPatch = ''
    substituteInPlace src/couch/rebar.config.script --replace '/usr/include/mozjs-91' "${spidermonkey_91.dev}/include/mozjs-91"
    substituteInPlace configure --replace '/usr/include/''${SM_HEADERS}' "${spidermonkey_91.dev}/include/mozjs-91"
    patchShebangs bin/rebar
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
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
    spidermonkey_91
    (python3.withPackages(ps: with ps; [ requests ]))
  ];

  dontAddPrefix= "True";

  configureFlags = [
    "--spidermonkey-version=91"
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
  };
}
