{ stdenv, fetchurl, openssl, python2, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool, fetchpatch
, callPackage
, darwin ? null
, enableNpm ? true
, enableSsl ? true
}@args:

let
  nodejs = import ./nodejs.nix args;
  baseName = if enableNpm then "nodejs" else "nodejs-slim";
in
  stdenv.mkDerivation (nodejs // rec {
    version = "4.8.1";
    name = "${baseName}-${version}";
    src = fetchurl {
      url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      sha256 = "0kcalypjf1036gr4mv1gy682hc1rp18ms3cv7mz0941qnizkzrms";
    };

  })
