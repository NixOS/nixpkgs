{ lib, stdenv, fetchurl, erlang, icu, openssl, spidermonkey_68
, coreutils, bash, makeWrapper, python3 }:

stdenv.mkDerivation rec {
  pname = "couchdb";
  version = "3.1.1";


  # when updating this, please consider bumping the erlang/OTP version
  # in all-packages.nix
  src = fetchurl {
    url = "mirror://apache/couchdb/source/${version}/apache-${pname}-${version}.tar.gz";
    sha256 = "18wcqxrv2bz88xadkqpqznprrxmcmwr0g6k895xrm8rbp9mpdzlg";
  };

  buildInputs = [ erlang icu openssl spidermonkey_68 (python3.withPackages(ps: with ps; [ requests ]))];
  postPatch = ''
    substituteInPlace src/couch/rebar.config.script --replace '/usr/include/mozjs-68' "${spidermonkey_68.dev}/include/mozjs-68"
    patchShebangs bin/rebar
  '';

  dontAddPrefix= "True";
  configureFlags = ["--spidermonkey-version=68"];
  buildFlags = ["release"];

  installPhase = ''
    mkdir -p $out
    cp -r rel/couchdb/* $out
  '';

  meta = with lib; {
    description = "A database that uses JSON for documents, JavaScript for MapReduce queries, and regular HTTP for an API";
    homepage = "http://couchdb.apache.org";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ lostnet ];
  };
}
