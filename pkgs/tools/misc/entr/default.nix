{ lib, stdenv, fetchurl, coreutils, ncurses }:

stdenv.mkDerivation rec {
  pname = "entr";
  version = "4.8";

  src = fetchurl {
    url = "https://eradman.com/entrproject/code/${pname}-${version}.tar.gz";
    sha256 = "1bi5fhr93n72pkap4mqsjd1pwnqjf6czg359c5xwczavfk6mamgh";
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
