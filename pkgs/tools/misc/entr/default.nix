{ stdenv, fetchurl, coreutils, ncurses }:

stdenv.mkDerivation rec {
  pname = "entr";
  version = "4.4";

  src = fetchurl {
    url = "http://entrproject.org/code/${pname}-${version}.tar.gz";
    sha256 = "1x2hyc8vc5dz6k7b3291vxz36wllhinvqrb0d8zx9bv0ydj6qmjl";
  };

  postPatch = ''
    substituteInPlace Makefile.bsd --replace /bin/echo echo
    substituteInPlace entr.c --replace /bin/cat ${coreutils}/bin/cat
    substituteInPlace entr.c --replace /usr/bin/clear ${ncurses.out}/bin/clear
    substituteInPlace entr.1 --replace /bin/cat cat
    substituteInPlace entr.1 --replace /usr/bin/clear clear
  '';
  dontAddPrefix = true;
  doCheck = true;
  checkTarget = "test";
  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://entrproject.org/;
    description = "Run arbitrary commands when files change";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub synthetica ];
  };
}
