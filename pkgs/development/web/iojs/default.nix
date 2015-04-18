{ stdenv, fetchurl, python, utillinux, openssl, http-parser, zlib, libuv, nightly ? false }:

let
  version = if nightly then "1.6.5-nightly20150409ff74931107" else "1.6.4";
  inherit (stdenv.lib) optional maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "iojs-${version}";

  src = fetchurl {
    url = if nightly
          then "https://iojs.org/download/nightly/v${version}/iojs-v${version}.tar.gz"
          else "https://iojs.org/dist/v${version}/iojs-v${version}.tar.gz";
    sha256 = if nightly
             then "04f7r4iv8p0jfylw4sxg3vsv14rbsi6n9hbqnwvdh6554yrm6d35"
             else "1qzvf7g457dppzxn23wppjcm09vh1n6bhsvz5szhwgjvl0iv2pc7";
  };

  prePatch = ''
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i configure
  '';

  configureFlags = [ "--shared-openssl" "--shared-http-parser" "--shared-zlib" "--shared-libuv" ];

  buildInputs = [ python openssl http-parser zlib libuv ] ++ (optional stdenv.isLinux utillinux);
  setupHook = ../nodejs/setup-hook.sh;

  passthru.interpreterName = "iojs";

  meta = {
    description = "A friendly fork of Node.js with an open governance model";
    homepage = https://iojs.org/;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
