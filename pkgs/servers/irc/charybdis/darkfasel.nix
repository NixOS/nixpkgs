{ stdenv, fetchgit, bison, flex, openssl }:

#stdenv.lib.overrideDerivation charybdis (x : {
stdenv.mkDerivation rec {
  name = "charybdis-darkfasel-git-2015-11-19";

  src = fetchgit {
    url = "https://github.com/darkfasel/charybdis.git";
    rev = "3c580b8793b4681742c87438c1207485b2359aff";
    sha256 = "560a04dbe39787140c6524e07e1982631b9f0405744d6ed4b280b6ff97a3edb1";
  };

  patches = [
     ./remove-setenv.patch
  ];

  configureFlags = [
    "--enable-epoll"
    "--enable-ipv6"
    "--enable-openssl=${openssl}"
    "--with-program-prefix=charybdis-"
    "--sysconfdir=/etc/charybdis"
  ];

  buildInputs = [ bison flex openssl ];

  meta = {
    description = "An extremely scalable ircd with some cooperation with the ratbox and ircu guys";
    homepage    = https://github.com/atheme/charybdis;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.lassulus ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
