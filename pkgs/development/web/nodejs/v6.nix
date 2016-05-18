{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
}@args:

import ./nodejs.nix (args // rec {
  version = "6.2.0";
  src = fetchurl {
    url = "https://nodejs.org/download/release/v${version}/node-v${version}.tar.gz";
    sha256 = "1fcldsnkk6px5fms405j9z2yv6mmscin5x7sma8bdavqgn283zgw";
  };
})
