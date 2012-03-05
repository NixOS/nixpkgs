{ stdenv, fetchurl, openssl, python, zlib, v8, darwinInstallNameToolUtility }:

stdenv.mkDerivation rec {
  version = "0.6.11";
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
    sha256 = "1lfb2f8b6j0wszvsmarzs17h1gwaqvz1rr4nbfnx4pv4c8nxpfwl";
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
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i tools/{*.py,waf-light,node-waf}
  '';

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libv8.dylib ${v8}/lib/libv8.dylib $out/bin/node
  '';

  buildInputs = [ python openssl v8 zlib ] ++ stdenv.lib.optional stdenv.isDarwin darwinInstallNameToolUtility;

  meta = with stdenv.lib; {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
