<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, cmake, gdb, qtcharts, qtbase, wrapQtAppsHook }:
=======
{ lib, stdenv, fetchFromGitHub, cmake, qtcharts, qtbase, wrapQtAppsHook }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  patchPhase = ''
    substituteInPlace src/{SeerGdbConfigPage,SeerMainWindow,SeerGdbWidget}.cpp \
      --replace "/usr/bin/gdb" "${gdb}/bin/gdb"
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ qtbase qtcharts ];
  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  meta = with lib; {
    description = "A Qt gui frontend for GDB";
    homepage = "https://github.com/epasveer/seer";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ foolnotion ];
  };
}
