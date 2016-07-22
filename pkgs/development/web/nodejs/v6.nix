{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
}@args:

import ./nodejs.nix (args // rec {
  version = "6.3.0";
  src = fetchurl {
    url = "https://nodejs.org/download/release/v${version}/node-v${version}.tar.xz";
    sha256 = "0b7npvxrby203z59r4jnd2v2x54lg8d2gc96c2gj3zyzzrdh3hk6";
  };
  extraConfigFlags = stdenv.lib.optionalString (stdenv.isDarwin) [ "--without-inspector" ];
  preBuild = stdenv.lib.optionalString (stdenv.isDarwin) ''
    sed -i -e "s|tr1/type_traits|type_traits|g" \
      -e "s|std::tr1|std|" src/util.h
  '';
})
