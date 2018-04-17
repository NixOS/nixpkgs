{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "thttpd-${version}";
  version = "2.28";

  src = fetchurl {
    url = "http://acme.com/software/thttpd/${name}.tar.gz";
    sha256 = "0a03w7wg994dizdb37pf4kd9s5lf2q414721jfqnrqpdshlzjll5";
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
