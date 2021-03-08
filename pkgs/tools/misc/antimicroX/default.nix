{ mkDerivation
, lib
, cmake
, extra-cmake-modules
, pkg-config
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
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "juliagoda";
    repo = "antimicroX";
    rev = version;
    sha256 = "05asxlkgb4cgvpcyksw1cx8cz8nzi8hmw8b91lw92892j7a2r7wj";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config itstool ];
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
