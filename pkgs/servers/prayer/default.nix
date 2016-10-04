{ stdenv, fetchurl, perl, openssl, db, zlib, uwimap, html-tidy, pam}:

let
  ssl = stdenv.lib.optionals uwimap.withSSL
    "-e 's/CCLIENT_SSL_ENABLE.*= false/CCLIENT_SSL_ENABLE=true/'";
in
stdenv.mkDerivation rec {
  name = "prayer-1.3.5";

  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/email/prayer/${name}.tar.gz";
    sha256 = "135fjbxjn385b6cjys6qhbwfw61mdcl2akkll4jfpdzfvhbxlyda";
  };

  patches = [ ./install.patch ];
  postPatch = ''
    sed -i -e s/gmake/make/ -e 's/LDAP_ENABLE.*= true/LDAP_ENABLE=false/' \
      ${ssl} \
      -e 's/CCLIENT_LIBS=.*/CCLIENT_LIBS=-lc-client/' \
      -e 's,^PREFIX .*,PREFIX='$out, \
      Config
    sed -i -e s,/usr/bin/perl,${perl}/bin/perl, \
      templates/src/*.pl
  '' + /* html-tidy updates */ ''
    substituteInPlace ./session/html_secure_tidy.c \
      --replace buffio.h tidybuffio.h
  '';

  buildInputs = [ openssl db zlib uwimap html-tidy pam ];
  nativeBuildInputs = [ perl ];

  NIX_LDFLAGS = "-lpam";

  meta = {
    homepage = http://www-uxsup.csx.cam.ac.uk/~dpc22/prayer/;
    description = "Yet another Webmail interface for IMAP servers on Unix systems written in C";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
