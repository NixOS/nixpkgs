{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qtbase
, qtquickcontrols2
, kirigami2
, oathToolkit
}:
mkDerivation rec {

  pname = "keysmith";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "keysmith";
    rev = "v${version}";
    sha256 = "15fzf0bvarivm32zqa5w71mscpxdac64ykiawc5hx6kplz93bsgx";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ oathToolkit kirigami2 qtquickcontrols2 qtbase ];

  meta = with lib; {
    description = "OTP client for Plasma Mobile and Desktop";
    license = licenses.gpl3;
    homepage = "https://github.com/KDE/keysmith";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
