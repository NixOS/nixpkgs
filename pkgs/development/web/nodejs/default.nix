{ stdenv, fetchurl, openssl, python }:

stdenv.mkDerivation rec {
  version = "0.4.7";
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/node-v${version}.tar.gz";
    sha256 = "1vixb54an9zp2zvc0z8pn6r6bv823wwy9m06xr4zzss9apw5yh2w";
  };

  patchPhase = ''
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i tools/{*.py,waf-light,node-waf}
  '';

  buildInputs = [ python openssl ];

  meta = with stdenv.lib; { 
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
