{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
}@args:

import ./nodejs.nix (args // rec {
  version = "6.1.0";
  src = fetchurl {
    url = "https://nodejs.org/download/release/v${version}/node-v${version}.tar.gz";
    sha256 = "1hsbmr3yc6zmyhz058zfxg77dzjhk94g1k0y65p6xq8ihq5yyrwy";
  };
})
