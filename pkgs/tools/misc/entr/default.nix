{ lib, stdenv, fetchurl, coreutils, ncurses, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "entr";
  version = "5.0";

  src = fetchurl {
    url = "https://eradman.com/entrproject/code/${pname}-${version}.tar.gz";
    sha256 = "1fqyshn9i213h6hiy31xlm719f6vayskfna92kvbd2aykryvp1ra";
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

  meta = with lib; {
    homepage = "https://eradman.com/entrproject/";
    description = "Run arbitrary commands when files change";
    changelog = "https://github.com/eradman/entr/raw/${version}/NEWS";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub synthetica ];
  };
}
