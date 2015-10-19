{ stdenv, fetchurl, libssl, libidn, ncurses, pcre, libssh, postgresql92 }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "thc-hydra-${version}";
  version = "7.5";

  src = fetchurl {
    url = "http://www.thc.org/releases/hydra-${version}.tar.gz";
    sha256 = "1dhavbn2mcm6c2c1qw29ipbpmczax3vhhlxzwn49c8cq471yg4vj";
  };

  preConfigure = ''
   substituteInPlace configure --replace "\$LIBDIRS" "${libssl}/lib ${pcre}/lib ${libssh}/lib ${postgresql92}/lib"
   substituteInPlace configure --replace "\$INCDIRS" "${libssl}/include ${pcre}/include ${libssh}/include ${postgresql92}/include"
  '';

  buildInputs = [ libssl libidn ncurses pcre libssh ];

  meta = {
    description = "A very fast network logon cracker which support many different services";
    license = licenses.agpl3;
    homepage = https://www.thc.org/thc-hydra/;
    maintainers = with maintainers; [offline];
    platforms = with platforms; unix;
  };
}
