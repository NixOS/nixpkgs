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
    version = "8.9.0";
    name = "${baseName}-${version}";
    src = fetchurl {
      url = "https://nodejs.org/download/release/v${version}/node-v${version}.tar.xz";
      sha256 = "128ir6rkdz1xj55hbflw0sh7snrrvjwgvxmgnka7cyhjkvw5i0mf";
    };

    patches = stdenv.lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  })
