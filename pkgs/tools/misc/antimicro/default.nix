{ stdenv, cmake, pkgconfig, SDL2, qtbase, qttools, xorg, fetchzip }:

stdenv.mkDerivation rec {
  name = "antimicro-${version}";
  version = "2.18";

  src = fetchzip {
    url    = "https://github.com/Ryochan7/antimicro/archive/${version}.tar.gz";
    sha256 = "0kyl4xl2am50v2xscgy2irpcdj78f7flgfhljyjck4ynf8d40vb7";
  };

  buildInputs = [
    cmake pkgconfig SDL2 qtbase qttools xorg.libXtst
  ];

  meta = with stdenv.lib; {
    description = "GUI for mapping keyboard and mouse controls to a gamepad";
    homepage = "https://github.com/Ryochan7/antimicro";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.gpl3;
  };
}
