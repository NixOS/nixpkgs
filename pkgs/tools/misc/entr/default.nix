{ stdenv, fetchurl, coreutils, ncurses }:

stdenv.mkDerivation rec {
  name = "entr-${version}";
  version = "3.2";

  src = fetchurl {
    url = "http://entrproject.org/code/${name}.tar.gz";
    sha256 = "0ikigpfzyjmr8j6snwlvxzqamrjbhlv78m8w1h0h7kzczc5f1vmi";
  };

  postPatch = ''
    substituteInPlace Makefile.bsd --replace /bin/echo echo
    substituteInPlace entr.c --replace /bin/cat ${coreutils}/bin/cat
    substituteInPlace entr.c --replace /usr/bin/clear ${ncurses}/bin/clear
    substituteInPlace entr.1 --replace /bin/cat cat
    substituteInPlace entr.1 --replace /usr/bin/clear clear
  '';
  dontAddPrefix = true;
  doCheck = true;
  checkTarget = "test";
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = http://entrproject.org/;
    description = "Run arbitrary commands when files change";

    license = stdenv.lib.licenses.isc;

    platforms = stdenv.lib.platforms.all;
  };
}
