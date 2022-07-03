{ stdenv, lib, fetchurl, ncurses }:
stdenv.mkDerivation rec {
  pname = "xstow";
  version = "1.0.2";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "6f041f19a5d71667f6a9436d56f5a50646b6b8c055ef5ae0813dcecb35a3c6ef";
  };

  buildInputs = [
    ncurses
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A replacement of GNU Stow written in C++";
    homepage = "http://xstow.sourceforge.net";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nzbr ];
    platforms = platforms.unix;
  };
}
