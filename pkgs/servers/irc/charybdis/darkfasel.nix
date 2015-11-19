{ stdenv, fetchgit, bison, flex, openssl }:

#stdenv.lib.overrideDerivation charybdis (x : {
stdenv.mkDerivation rec {
  name = "charybdis-darkfasel-git-2015-11-19";

  src = fetchgit {
    url = "https://github.com/darkfasel/charybdis.git";
    rev = "cda5778a4a04b53d7b507c63c0664259e423a37f";
    sha256 = "1z8frj95q068rbcxb05ppzgbayih2nhqrp2dacllch4j9lx533a8";
  };

  patches = [
     ./remove-setenv.patch
  ];

  configureFlags = [
    "--enable-epoll"
    "--enable-ipv6"
    "--enable-openssl=${openssl}"
    "--with-program-prefix=charybdis-"
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
