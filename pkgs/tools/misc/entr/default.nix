{ lib, stdenv, fetchurl, coreutils, ncurses, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "entr";
  version = "4.9";

  src = fetchurl {
    url = "https://eradman.com/entrproject/code/${pname}-${version}.tar.gz";
    sha256 = "sha256-4lak0vvkb2EyRggzukR+ZdfzW6nQsmXnxBUDl8xEBaI=";
  };

  patches = lib.optionals stdenv.isDarwin [
    # Fix v4.9 segfault on Darwin. remove with the next update
    # https://github.com/eradman/entr/issues/74
    (fetchpatch {
      url = "https://github.com/eradman/entr/commit/468d77d45925abba826bb1dcda01487dbe37eb33.patch";
      sha256 = "17kkcrsnac0pb930sf2kix71h4c7krzsrvz8pskx0vm39n1c9xfi";
      includes = [ "entr.c" ];
    })
  ];

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
