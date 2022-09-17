{ lib, stdenv, fetchurl, erlang, icu, openssl, spidermonkey_91
, coreutils, bash, python3, nixosTests }:

stdenv.mkDerivation rec {
  pname = "couchdb";
  version = "3.2.2";


  # when updating this, please consider bumping the erlang/OTP version
  # in all-packages.nix
  src = fetchurl {
    url = "mirror://apache/couchdb/source/${version}/apache-${pname}-${version}.tar.gz";
    sha256 = "sha256-acn9b4ATNVf2igLpLdpypP1kbWRvQp9Fu4Mpow+C8g4=";
  };

  nativeBuildInputs = [
    erlang
  ];
  buildInputs = [ icu openssl spidermonkey_91 (python3.withPackages(ps: with ps; [ requests ]))];
  postPatch = ''
    substituteInPlace src/couch/rebar.config.script --replace '/usr/include/mozjs-91' "${spidermonkey_91.dev}/include/mozjs-91"
    patchShebangs bin/rebar
  '';

  dontAddPrefix= "True";
  configureFlags = ["--spidermonkey-version=91"];
  buildFlags = ["release"];

  installPhase = ''
    mkdir -p $out
    cp -r rel/couchdb/* $out
  '';

  passthru.tests = {
    inherit (nixosTests) couchdb;
  };

  meta = with lib; {
    description = "A database that uses JSON for documents, JavaScript for MapReduce queries, and regular HTTP for an API";
    homepage = "https://couchdb.apache.org";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ lostnet ];
  };
}
