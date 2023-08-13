{ mkDerivation, lib, fetchFromGitLab, cmake, extra-cmake-modules
, ki18n
, kitemmodels
, oath-toolkit
, qgpgme
, plasma-framework
, qt5 }:

mkDerivation rec {
  pname = "plasma-pass";
  version = "1.2.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "plasma-pass";
    sha256 = "sha256-lCNskOXkSIcMPcMnTWE37sDCXfmtP0FhyMzxeF6L0iU=";

    # So the tag is actually "v0.2.1" but the released version is later than
    # 1.2.0 and the "release" on the gitlab page also says "1.2.1".
    # I guess they just messed up the tag subject and description.
    # Maintainer of plasma-pass was notified about this 2023-08-13
    rev = "v0.2.1";
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

