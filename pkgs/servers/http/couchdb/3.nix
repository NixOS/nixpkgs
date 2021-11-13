{ lib, stdenv, fetchurl, erlang, icu, openssl, spidermonkey_78
, coreutils, bash, makeWrapper, python3, nixosTests }:

stdenv.mkDerivation rec {
  pname = "couchdb";
  version = "3.2.1";


  # when updating this, please consider bumping the erlang/OTP version
  # in all-packages.nix
  src = fetchurl {
    url = "mirror://apache/couchdb/source/${version}/apache-${pname}-${version}.tar.gz";
    sha256 = "1y5cfic88drlr9qiwyj2p8xc9m9hcbvw77j5lwbp0cav78f2vphi";
  };

  buildInputs = [ erlang icu openssl spidermonkey_78 (python3.withPackages(ps: with ps; [ requests ]))];
  postPatch = ''
    substituteInPlace src/couch/rebar.config.script --replace '/usr/include/mozjs-78' "${spidermonkey_78.dev}/include/mozjs-78"
    patchShebangs bin/rebar
  '';

  dontAddPrefix= "True";
  configureFlags = ["--spidermonkey-version=78"];
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
    homepage = "http://couchdb.apache.org";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ lostnet ];
  };
}
