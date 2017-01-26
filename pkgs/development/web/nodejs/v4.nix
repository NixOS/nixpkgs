{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
}@args:

import ./nodejs.nix (args // rec {
  version = "4.6.2";
  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
    sha256 = "17ick2r2biyxs5zf83i8q8844fbcphm0d5g1z70mcrb86yrmi545";
  };
  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e "s|tr1/type_traits|type_traits|g" \
    -e "s|std::tr1|std|" src/util.h
  '';
})
