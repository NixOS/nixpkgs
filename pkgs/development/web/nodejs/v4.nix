{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
}@args:

import ./nodejs.nix (args // rec {
  version = "4.5.0";
  src = fetchurl {
    url = "https://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
    sha256 = "126l7drvxzyifjnsw1kzi4r67i365s75c2c44122902nihvrvfcp";
  };
})
