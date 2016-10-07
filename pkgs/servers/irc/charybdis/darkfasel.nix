{ stdenv, fetchFromGitHub, bison, flex, openssl }:

#stdenv.lib.overrideDerivation charybdis (x : {
stdenv.mkDerivation rec {
  name = "charybdis-darkfasel-git-2016-02-18";

  src = fetchFromGitHub {
    repo = "charybdis";
    owner = "darkfasel";
    rev = "3643aa7943f19d9379da661d2e1e98d70486b3b4";
    sha256 = "07bnp1s13ys3nb9d5iydcz4xjjr29lavyc12ghswd76wn58igz93";
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
