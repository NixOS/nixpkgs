{ stdenv, fetchurl, openssl, python, zlib, v8, utillinux, http_parser, c-ares, pkgconfig, runCommand }:

let
  dtrace = runCommand "dtrace-native" {} ''
    mkdir -p $out/bin
    ln -sv /usr/sbin/dtrace $out/bin
  '';

  version = "0.10.21";

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

  inherit (stdenv.lib) concatMap optional optionals maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
    sha256 = "038l4j0ilrsmc6m2z2qprqs82z7p4940scb8597hcmhp5kr5n4kw";
  };

  configureFlags = concatMap sharedConfigureFlags (builtins.attrNames deps);

  prePatch = ''
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i configure
  '';

  patches = if stdenv.isDarwin then [ ./no-xcode.patch ] else null;

  postPatch = if stdenv.isDarwin then ''
    (cd tools/gyp; patch -Np1 -i ${../../python-modules/gyp/no-darwin-cflags.patch})
  '' else null;

  buildInputs = [ python openssl ]
    ++ (optional stdenv.isLinux utillinux)
    ++ optionals stdenv.isDarwin [ pkgconfig dtrace ];
  setupHook = ./setup-hook.sh;

  meta = {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu maintainers.shlevy ];
    platforms = platforms.linux;
  };
}
