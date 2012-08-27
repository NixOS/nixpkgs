{ stdenv, fetchurl, openssl, python, zlib, v8, linkV8Headers ? false, utillinux }:

let

  espipe_patch = fetchurl {
    url = https://github.com/joyent/libuv/commit/0ac2fdc55455794e057e4999a2e785ca8fbfb1b2.patch;
    sha256 = "0mqgbsz23b3zp19dwk12ys14b031hssmlp40dylb7psj937qcpzi";
  };

in

stdenv.mkDerivation rec {
  version = "0.8.8";
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
    sha256 = "0cri5r191l5pw8a8pf3gs7hfjm3rrz6kdnm3l8wghmp9p12p0aq9";
  };

  configureFlags = [
    "--openssl-includes=${openssl}/include"
    "--openssl-libpath=${openssl}/lib"
    "--shared-v8"
    "--shared-v8-includes=${v8}/includes"
    "--shared-v8-libpath=${v8}/lib"
  ];

  patches = stdenv.lib.optional stdenv.isDarwin ./no-arch-flag.patch;

  prePatch = ''
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i tools/{*.py,waf-light,node-waf} configure
    pushd deps/uv
    patch -p 1 < ${espipe_patch}
    popd
  '';

  postInstall = ''
    sed -e 's|^#!/usr/bin/env node$|#!'$out'/bin/node|' -i $out/lib/node_modules/npm/bin/npm-cli.js
  '' + stdenv.lib.optionalString linkV8Headers '' # helps binary npms
    ln -s ${v8}/include/* $out/include
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libv8.dylib ${v8}/lib/libv8.dylib $out/bin/node
  '';

  buildInputs = [ python openssl v8 zlib ] ++ stdenv.lib.optional stdenv.isLinux utillinux;

  meta = with stdenv.lib; {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
