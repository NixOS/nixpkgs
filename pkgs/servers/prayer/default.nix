{ stdenv, fetchurl, perl, openssl, db4, zlib, uwimap, htmlTidy, pam}:

let
  ssl = stdenv.lib.optionals uwimap.withSSL
    "-e 's/CCLIENT_SSL_ENABLE.*= false/CCLIENT_SSL_ENABLE=true/'";
in
stdenv.mkDerivation rec {
  name = "prayer-1.3.4";
  
  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/email/prayer/${name}.tar.gz";
    sha256 = "0a2nmrlwdq4n5019j3mw2xbbc61s7sssjih5ql6r5rvyrrr48szc";
  };

  buildInputs = [ openssl db4 zlib uwimap htmlTidy pam ];
  nativeBuildInputs = [ perl ];

  NIX_LDFLAGS = "-lpam";

  patches = [ ./install.patch ];
  postPatch = ''
    sed -i -e s/gmake/make/ -e 's/LDAP_ENABLE.*= true/LDAP_ENABLE=false/' \
      ${ssl} \
      -e 's/CCLIENT_LIBS=.*/CCLIENT_LIBS=-lc-client/' \
      -e 's,^PREFIX .*,PREFIX='$out, \
      Config
    sed -i -e s,/usr/bin/perl,${perl}/bin/perl, \
      templates/src/*.pl
  '';

  meta = {
    homepage = http://www-uxsup.csx.cam.ac.uk/~dpc22/prayer/;
    description = "Yet another Webmail interface for IMAP servers on Unix systems written in C";
    license = "GPLv2+";
  };
}
