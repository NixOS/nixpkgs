{ stdenv, fetchurl, coreutils, ncurses }:

stdenv.mkDerivation rec {
  name = "entr-${version}";
  version = "3.5";

  src = fetchurl {
    url = "http://entrproject.org/code/${name}.tar.gz";
    sha256 = "05k4jyjna0pr2dalwc1l1dhrcyk6pw7hbss7jl4ykwfadcs5br73";
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
