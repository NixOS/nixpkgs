{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
}@args:

import ./nodejs.nix (args // rec {
  version = "4.4.4";
  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
    sha256 = "055i4wcc5sfqv7ksdxwbxpy4v1qc16lkzgbyhx46cnhl072fv71c";
  };
})
