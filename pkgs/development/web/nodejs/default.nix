{ stdenv, fetchurl, openssl, python }:

stdenv.mkDerivation rec {
  version = "0.5.2";
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
    sha256 = "16z16gq5pibw5l830pv5dgx7v2gw6syrddphikcgia92pw4r33qr";
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
