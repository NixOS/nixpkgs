{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "thttpd-${version}";
  version = "2.26";

  src = fetchurl {
    url = "http://acme.com/software/thttpd/${name}.tar.gz";
    sha256 = "1dybhpyfrly0m285cdn9jah397bqzylrwzi26gin2h451z3gdcqm";
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
