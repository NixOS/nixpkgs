{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
}@args:

import ./nodejs.nix (args // rec {
  version = "6.2.0";
  src = fetchurl {
    url = "https://nodejs.org/download/release/v${version}/node-v${version}.tar.xz";
    sha256 = "14p4ah9gsgifj25g2akp7kyqhnqvq726n74h4rfj7wnidxhgwcw6";
  };
})
