{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "thttpd-${version}";
  version = "2.25b";

  src = fetchurl {
    url = "http://acme.com/software/thttpd/${name}.tar.gz";
    sha256 = "0q13sfkh6amn5wk0ccbmxq3mnhlm8g5pnyk910fa5xngn449nw87";
  };

  prePatch = ''
    sed -i -e 's/getline/getlineX/' extras/htpasswd.c
  '';

  preInstall = ''
    mkdir -p "$out/man/man1"
    sed -i -e 's/-o bin -g bin *//' Makefile
    sed -i -e '/chgrp/d' extras/Makefile
  '';

  meta = {
    description = "Tiny/turbo/throttling HTTP server";
    homepage = "http://www.acme.com/software/thttpd/";
    license = stdenv.lib.licenses.bsd2;
  };
}
