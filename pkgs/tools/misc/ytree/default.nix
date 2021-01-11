{ lib, stdenv
, fetchurl
, ncurses
, readline
}:

stdenv.mkDerivation rec {
  pname = "ytree";
  version = "2.03";

  src = fetchurl {
    url = "https://han.de/~werner/${pname}-${version}.tar.gz";
    sha256 = "sha256-WDqnFVLRNH4Oq+OaI2+loXS/Z93piHGFO5/iojO8rvE=";
  };

  buildInputs = [
    ncurses
    readline
  ];

  # don't save timestamp, in order to improve reproducibility
  postPatch = ''
    substituteInPlace Makefile --replace 'gzip' 'gzip -n'
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = with lib; {
    description = "A curses-based file manager similar to DOS Xtree(TM)";
    homepage = "https://www.han.de/~werner/ytree.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
# TODO: X11 support
