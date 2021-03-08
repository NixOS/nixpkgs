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
  version = "0.11.99.0";
  src = fetchFromGitLab {
    owner = "aerusso";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h4ymvzihzbmyv3z0bp28g94wxc6c7lgi3my0xbka3advxr811gn";
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
