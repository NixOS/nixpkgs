{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
}@args:

import ./nodejs.nix (args // rec {
  version = "6.2.2";
  src = fetchurl {
    url = "https://nodejs.org/download/release/v${version}/node-v${version}.tar.xz";
    sha256 = "2dfeeddba750b52a528b38a1c31e35c1fb40b19cf28fbf430c3c8c7a6517005a";
  };
})
