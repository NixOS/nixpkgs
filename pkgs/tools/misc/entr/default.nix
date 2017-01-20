{ stdenv, fetchurl, coreutils, ncurses }:

stdenv.mkDerivation rec {
  name = "entr-${version}";
  version = "3.6";

  src = fetchurl {
    url = "http://entrproject.org/code/${name}.tar.gz";
    sha256 = "1sy81np6kgmq04kfn2ckf4fp7jcf5d1963shgmapx3al3kc4c9x4";
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
