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
    version = "8.2.1";
    name = "${baseName}-${version}";
    src = fetchurl {
      url = "https://nodejs.org/download/release/v${version}/node-v${version}.tar.xz";
      sha256 = "12wcmm2g1zlihja41my5r06sla0s6ygvycxds1ryl3jl2j4nvi02";
    };

    patches = stdenv.lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  })

