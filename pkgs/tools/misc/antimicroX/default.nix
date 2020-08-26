{ mkDerivation
, lib
, cmake
, extra-cmake-modules
, pkgconfig
, SDL2
, qtbase
, qttools
, qtx11extras
, xorg
, fetchFromGitHub
, itstool
}:

mkDerivation rec {
  pname = "antimicroX";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "juliagoda";
    repo = "antimicroX";
    rev = version;
    sha256 = "0li22sjl95233azxhyda36idnfzbb4b02wf57hnpnba6qvrlpwwl";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig itstool ];
  buildInputs = [
    SDL2
    qtbase
    qttools
    qtx11extras
    xorg.libX11
    xorg.libXtst
    xorg.libXi
  ];

  meta = with lib; {
    description = "GUI for mapping keyboard and mouse controls to a gamepad";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.gpl3Plus;
    platforms = with platforms; linux;
  };
}
