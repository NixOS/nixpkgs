{
  lib,
  fetchFromGitLab,
  mkDerivation,
  qtbase,
  cmake,
  kconfig,
  kio,
  kiconthemes,
  kxmlgui,
  ki18n,
  kguiaddons,
  extra-cmake-modules,
  boost,
  shared-mime-info,
  rrdtool,
  breeze-icons,
}:

mkDerivation rec {
  pname = "kcollectd";
  version = "0.12.1";
  src = fetchFromGitLab {
    owner = "aerusso";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bUVL5eRQ5UkSZo562pnyEcj0fVoSC5WHRq4BfN67jEM=";
  };

  postPatch = lib.optional (!lib.versionOlder rrdtool.version "1.9.0") ''
    substituteInPlace kcollectd/rrd_interface.cc --replace-fail 'char *arg[] =' 'const char *arg[] ='
  '';

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
    description = "Graphical frontend to collectd";
    homepage = "https://www.antonioerusso.com/projects/kcollectd/";
    maintainers = [ maintainers.symphorien ];
    license = [ lib.licenses.gpl3Plus ];
    platforms = lib.platforms.linux;
    mainProgram = "kcollectd";
  };
}
