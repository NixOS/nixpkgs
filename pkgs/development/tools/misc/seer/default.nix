{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gdb,
  kdePackages,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "seer";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "epasveer";
    repo = "seer";
    rev = "v${version}";
    sha256 = "sha256-+3yghoK8fAM6UFomv1Ga05kxwsLcoL2CpuIDXkFfWHc=";
  };

  preConfigure = ''
    cd src
  '';

  patchPhase = ''
    substituteInPlace src/{SeerGdbConfigPage,SeerMainWindow,SeerGdbWidget}.cpp \
      --replace-fail "/usr/bin/gdb" "${gdb}/bin/gdb"
  '';

  buildInputs = with kdePackages; [
    qtbase
    qtcharts
    qtsvg
  ];
  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
  ];

  meta = with lib; {
    description = "Qt gui frontend for GDB";
    mainProgram = "seergdb";
    homepage = "https://github.com/epasveer/seer";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ foolnotion ];
  };
}
