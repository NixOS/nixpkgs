{ stdenv, fetchurl, python, utillinux, openssl, http-parser, zlib, libuv, nightly ? false }:

let
  version = if nightly then "1.5.2-nightly201503173c8ae2d934" else "1.5.1";
  inherit (stdenv.lib) optional maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "iojs-${version}";

  src = fetchurl {
    url = if nightly
          then "https://iojs.org/download/nightly/v${version}/iojs-v${version}.tar.gz"
          else "https://iojs.org/dist/v${version}/iojs-v${version}.tar.gz";
    sha256 = if nightly
             then "10blf1hr80fknrzyrbj7qy2xn7wilnyn6y2r7ijrw2gns4ia3d0h"
             else "0zdxdb9n0yk6dp6j6x3bka7vrnf7kz8jjcpl6fw5fr9f742s9s26";
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
