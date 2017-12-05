{ stdenv, fetchurl, openssl, python2, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool, fetchpatch
, callPackage
, darwin ? null
, enableNpm ? true
}@args:

let
  nodejs = import ./nodejs.nix args;
  baseName = if enableNpm then "nodejs" else "nodejs-slim";
in
  stdenv.mkDerivation (nodejs // rec {
    version = "4.8.4";
    name = "${baseName}-${version}";
    src = fetchurl {
      url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      sha256 = "35fe633a48cbe93c79327161d9dc964ac9810f4ceb2ed8628487e6e14a15905b";
    };

  })
