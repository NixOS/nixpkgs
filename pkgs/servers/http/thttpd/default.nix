{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "thttpd-${version}";
  version = "2.27";

  src = fetchurl {
    url = "http://acme.com/software/thttpd/${name}.tar.gz";
    sha256 = "0ykda5k1zzzag59zbd4bkzj1psavq0xnpy7vpk19rhx7mlvvri5i";
  };

  prePatch = ''
    sed -i -e 's/getline/getlineX/' extras/htpasswd.c
    sed -i -e 's/chmod 2755/chmod 755/' extras/Makefile.in
  '';

  preInstall = ''
    mkdir -p "$out/man/man1"
    sed -i -e 's/-o bin -g bin *//' Makefile
    sed -i -e '/chgrp/d' extras/Makefile
  '';

  meta = {
    description = "Tiny/turbo/throttling HTTP server";
    homepage = http://www.acme.com/software/thttpd/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
  };
}
