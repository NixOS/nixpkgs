{ stdenv, fetchurl, openssl, python, zlib }:

stdenv.mkDerivation rec {
  version = "0.6.6";
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
    sha256 = "00i14bjhyadxrh0df1ig4ndv1c0b7prnnhyar5lxcgxnn4cabgks";
  };

  configureFlags = [
    "--openssl-includes=${openssl}/include"
    "--openssl-libpath=${openssl}/lib"
  ];

  patchPhase = ''
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i tools/{*.py,waf-light,node-waf}
  '';

  buildInputs = [ python openssl zlib ];

  meta = with stdenv.lib; {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
