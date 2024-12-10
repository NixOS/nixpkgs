{
  mkDerivation,
  lib,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  ki18n,
  kitemmodels,
  oath-toolkit,
  qgpgme,
  plasma-framework,
  qt5,
}:

mkDerivation rec {
  pname = "plasma-pass";
  version = "1.2.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "plasma-pass";
    sha256 = "sha256-fEYH3cvDZzEKpYqkTVqxxh3rhV75af8dZUHxQq8fPNg=";
    rev = "v${version}";
  };

  buildInputs = [
    ki18n
    kitemmodels
    oath-toolkit
    qgpgme
    plasma-framework
    qt5.qtbase
    qt5.qtdeclarative
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "A Plasma applet to access passwords from pass, the standard UNIX password manager";
    homepage = "https://invent.kde.org/plasma/plasma-pass";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
  };
}
