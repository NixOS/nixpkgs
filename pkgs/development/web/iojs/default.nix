{ stdenv, fetchurl, python, utillinux, openssl, http-parser, zlib, nightly ? false }:

let
  version = if nightly then "1.2.1-nightly20150213f0296933f8" else "1.2.0";
  inherit (stdenv.lib) optional maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "iojs-${version}";

  src = fetchurl {
    url = if nightly
          then "https://iojs.org/download/nightly/v${version}/iojs-v${version}.tar.gz"
          else "https://iojs.org/dist/v${version}/iojs-v${version}.tar.gz";
    sha256 = if nightly
             then "0v9njaggddi128v58rd34qknph8pn9c653gqd4y29l1mwjvqg62s"
             else "17axqswpl252gliak1wjc2l9jk6n5jqdfa9f1vv7x9acj776yrik";
  };

  prePatch = ''
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i configure
  '';

  configureFlags = [ "--shared-openssl" "--shared-http-parser" "--shared-zlib" ];

  buildInputs = [ python openssl http-parser zlib ] ++ (optional stdenv.isLinux utillinux);
  setupHook = ../nodejs/setup-hook.sh;

  meta = {
    description = "A friendly fork of Node.js with an open governance model";
    homepage = https://iojs.org/;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
