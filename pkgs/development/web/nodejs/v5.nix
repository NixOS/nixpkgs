{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
}@args:

import ./nodejs.nix (args // rec {
  version = "5.11.1";
  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
    sha256 = "07v60mhswj77m7516zakj3p1py7ixa5jbgj0m7zlr9vygrrc66zi";
  };
})
