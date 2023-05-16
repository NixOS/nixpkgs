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
<<<<<<< HEAD
  version = "3.3.4";
=======
  version = "3.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "AntiMicroX";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-WEtKeQKRZcYpZ4mnFdj4ZRApBuD8fByf11Uu6ylbAcY=";
=======
    sha256 = "sha256-svEk+IFttkCXmoAOFH3k2rRC/OL9HXOLiuGrCh10YNc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  };
}
