{ mkDerivation
, lib
, cmake
, extra-cmake-modules
, pkg-config
, SDL2
, qttools
, xorg
, fetchFromGitHub
, itstool
}:

mkDerivation rec {
  pname = "antimicrox";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "AntiMicroX";
    repo = pname;
    rev = version;
    sha256 = "sha256-zBIEuZdmcyA99YdwC6tn0I3Ori8VyBOw50ablb/Lmvs=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config itstool ];
  buildInputs = [
    SDL2
    qttools
    xorg.libXtst
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
        --replace "/usr/lib/udev/rules.d/" "$out/lib/udev/rules.d/"
  '';

  meta = with lib; {
    description = "GUI for mapping keyboard and mouse controls to a gamepad";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ sbruder ];
    license = licenses.gpl3Plus;
    platforms = with platforms; linux;
    mainProgram = "antimicrox";
  };
}
