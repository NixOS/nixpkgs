{ stdenv, fetchurl, coreutils, ncurses }:

stdenv.mkDerivation rec {
  name = "entr-${version}";
  version = "3.9";

  src = fetchurl {
    url = "http://entrproject.org/code/${name}.tar.gz";
    sha256 = "0xk8y8asy0wxi5jx03c521p9919gjr8053lxpfzn83jkmqc8zmq2";
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
    maintainers = with maintainers; [ pSub ];
  };
}
