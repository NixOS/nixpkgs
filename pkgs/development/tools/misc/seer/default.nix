{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gdb,
  qtcharts,
  qtbase,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "seer";
  version = "1.17";

  src = fetchFromGitHub {
    owner = "epasveer";
    repo = "seer";
    rev = "v${version}";
    sha256 = "sha256-lM6w+QwIRYP/2JDx4yynJxhVXt8SouOWgsLGXSwolIw=";
  };

  preConfigure = ''
    cd src
  '';

  patchPhase = ''
    substituteInPlace src/{SeerGdbConfigPage,SeerMainWindow,SeerGdbWidget}.cpp \
      --replace "/usr/bin/gdb" "${gdb}/bin/gdb"
  '';

  buildInputs = [
    qtbase
    qtcharts
  ];
  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  meta = with lib; {
    description = "A Qt gui frontend for GDB";
    mainProgram = "seergdb";
    homepage = "https://github.com/epasveer/seer";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ foolnotion ];
  };
}
