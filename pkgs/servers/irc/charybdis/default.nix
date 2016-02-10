{ stdenv, fetchgit, bison, flex, openssl }:

stdenv.mkDerivation rec {
  name = "charybdis-3.5.0-rc1";

  src = fetchgit {
    url = "https://github.com/atheme/charybdis.git";
    rev = "43a9b61c427cd0f3fa2c192890b8a48d9ea6fb7f";
    sha256 = "ae2c8a72e6a29c901f9b51759b542ee12c4ec918050a2d9d65e5635077a0fcef";
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

  hardening_format = false;

  buildInputs = [ bison flex openssl ];

  meta = {
    description = "An extremely scalable ircd with some cooperation with the ratbox and ircu guys";
    homepage    = https://github.com/atheme/charybdis;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.lassulus ];
    platforms   = stdenv.lib.platforms.linux;
  };


}
