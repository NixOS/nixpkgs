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
  version = "2.6";

  src = fetchFromGitHub {
    owner = "epasveer";
    repo = "seer";
    rev = "v${version}";
    sha256 = "sha256-QXVsjTJYGE/7nTKldlOGN6AnW8OthrBJruVbb/HiPdg=";
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

  meta = {
    description = "Qt gui frontend for GDB";
    mainProgram = "seergdb";
    homepage = "https://github.com/epasveer/seer";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ foolnotion ];
  };
}
