{ stdenv, fetchurl, fetchpatch, perl, openssl, db, zlib, uwimap, html-tidy, pam}:

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

  patches = [
    ./install.patch

    # fix build errors which result from openssl changes
    (fetchpatch {
      url = "https://sources.debian.org/data/main/p/prayer/1.3.5-dfsg1-6/debian/patches/disable_ssl3.patch";
      sha256 = "1rx4bidc9prh4gffipykp144cyi3zd6qzd990s2aad3knzv5bkdd";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/p/prayer/1.3.5-dfsg1-6/debian/patches/openssl1.1.patch";
      sha256 = "0zinylvq3bcifdmki867gir49pbjx6qb5h019hawwif2l4jmlxw1";
    })
  ];

  postPatch = ''
    sed -i -e s/gmake/make/ -e 's/LDAP_ENABLE.*= true/LDAP_ENABLE=false/' \
      ${ssl} \
      -e 's/CCLIENT_LIBS=.*/CCLIENT_LIBS=-lc-client/' \
      -e 's,^PREFIX .*,PREFIX='$out, \
      -e 's,^CCLIENT_DIR=.*,CCLIENT_DIR=${uwimap}/include/c-client,' \
      Config
    sed -i -e s,/usr/bin/perl,${perl}/bin/perl, \
      templates/src/*.pl
    sed -i -e '/<stropts.h>/d' lib/os_linux.h
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
