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
    version = "4.8.7";
    name = "${baseName}-${version}";
    src = fetchurl {
      url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      sha256 = "1y21wq092d3gmccm2zldbflbbbx7a71wi9l0bpkxvzmgws69liq3";
    };

  })
