{ mkDerivation, lib, fetchFromGitLab, cmake, extra-cmake-modules
, ki18n
, kitemmodels
, oath-toolkit
, qgpgme
, plasma-framework
, qt5 }:

mkDerivation rec {
  pname = "plasma-pass";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "plasma-pass";
<<<<<<< HEAD
    sha256 = "sha256-lCNskOXkSIcMPcMnTWE37sDCXfmtP0FhyMzxeF6L0iU=";
    rev = "v${version}";
=======
    rev = "v${version}";
    sha256 = "1w2mzxyrh17x7da62b6sg1n85vnh1q77wlrfxwfb1pk77y59rlf1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs  = [
    ki18n
    kitemmodels
    oath-toolkit
    qgpgme
    plasma-framework
    qt5.qtbase
    qt5.qtdeclarative
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  meta = with lib; {
    description = "A Plasma applet to access passwords from pass, the standard UNIX password manager";
    homepage = "https://invent.kde.org/plasma/plasma-pass";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
  };
}

