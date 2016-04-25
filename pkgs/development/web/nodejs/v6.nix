{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
}@args:

import ./nodejs.nix (args // rec {
  version = "6.0.0";
  src = fetchurl {
    url = "https://nodejs.org/download/release/v${version}/node-v${version}.tar.gz";
    sha256 = "0cpw7ng193jgfbw2g1fd0kcglmjjkbj4xb89g00z8zz0lj0nvdbd";
  };
})
