{ lib
, fetchFromGitLab
, mkDerivation
, qtbase
, cmake
, kconfig
, kio
, kiconthemes
, kxmlgui
, ki18n
, kguiaddons
, extra-cmake-modules
, boost
, shared-mime-info
, rrdtool
, breeze-icons
}:

mkDerivation rec {
  pname = "kcollectd";
  version = "0.12.0";
  src = fetchFromGitLab {
    owner = "aerusso";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ihd4Ps4t9+sNB3joO3vTxDR/25t7Ecl6yvHQ15QiUdY=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    shared-mime-info
  ];

  buildInputs = [
    qtbase
    kconfig
    kio
    kxmlgui
    kiconthemes
    ki18n
    kguiaddons
    boost
    rrdtool
    # otherwise some buttons are blank
    breeze-icons
  ];

  meta = with lib; {
    description = "A graphical frontend to collectd";
    homepage = "https://www.antonioerusso.com/projects/kcollectd/";
    maintainers = [ maintainers.symphorien ];
    license = [ lib.licenses.gpl3Plus ];
    platforms = lib.platforms.linux;
  };
}
