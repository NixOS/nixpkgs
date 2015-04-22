{ stdenv, fetchurl, python, utillinux, openssl, http-parser, zlib, libuv }:

let
  version = "1.8.1";
  inherit (stdenv.lib) optional maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "iojs-${version}";

  src = fetchurl {
    url = "https://iojs.org/dist/v${version}/iojs-v${version}.tar.gz";
    sha256 = "06z1f2xn6jj3cr1irdghp4jmc9hzbxcqlcwlsr3787ng02v0gm07";
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
