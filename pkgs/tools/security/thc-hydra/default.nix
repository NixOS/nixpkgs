{ stdenv, fetchurl, pkgconfig, openssl, libidn, ncurses, pcre, libssh, postgresql92 }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "thc-hydra-${version}";
  version = "7.5";

  src = fetchurl {
    url = "http://www.thc.org/releases/hydra-${version}.tar.gz";
    sha256 = "1dhavbn2mcm6c2c1qw29ipbpmczax3vhhlxzwn49c8cq471yg4vj";
  };

  preConfigure = ''
   substituteInPlace configure --replace "\$LIBDIRS" "${openssl.out}/lib ${pcre.out}/lib ${libssh.out}/lib ${postgresql92.lib}/lib"
   substituteInPlace configure --replace "\$INCDIRS" "${openssl.dev}/include ${pcre.dev}/include ${libssh.dev}/include ${postgresql92}/include"
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libidn ncurses pcre libssh ];

  meta = {
    description = "A very fast network logon cracker which support many different services";
    license = licenses.agpl3;
    homepage = https://www.thc.org/thc-hydra/;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
