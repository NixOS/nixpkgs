{ stdenv, fetchurl, openssl, python, zlib, v8, utillinux, http_parser, c-ares }:

let
  version = "0.10.8";

  # !!! Should we also do shared libuv?
  deps = {
    inherit v8 openssl zlib;
    cares = c-ares;
    http-parser = http_parser;
  };

  sharedConfigureFlags = name: [
    "--shared-${name}"
    "--shared-${name}-includes=${builtins.getAttr name deps}/include"
    "--shared-${name}-libpath=${builtins.getAttr name deps}/lib"
  ];

  inherit (stdenv.lib) concatMap optional maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
    sha256 = "0m43y7ipd6d89dl97nvrwkx1zss3fdb9835509dyziycr1kggxpd";
  };

  configureFlags = concatMap sharedConfigureFlags (builtins.attrNames deps);

  prePatch = ''
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i configure
  '';

  buildInputs = [ python ]
    ++ optional stdenv.isLinux utillinux;
  setupHook = ./setup-hook.sh;

  meta = {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu maintainers.shlevy ];
    platforms = platforms.linux;
  };
}
