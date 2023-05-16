{ lib, stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "smenu";

  src = fetchFromGitHub {
    owner = "p-gen";
    repo = "smenu";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-r2N+MmZI2KCuYarrFL2Xn5hu4FO3n5MqADRuTXMOtk0=";
=======
    sha256 = "sha256-DfND2lIHQc+7+8lM86MMOdFKhbUAOnSlkpLwxo10EI4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ ncurses ];

  meta = with lib; {
    homepage = "https://github.com/p-gen/smenu";
    description = "Terminal selection utility";
    longDescription = ''
      Terminal utility that allows you to use words coming from the standard
      input to create a nice selection window just below the cursor. Once done,
      your selection will be sent to standard output.
    '';
    license = licenses.gpl2Only;
<<<<<<< HEAD
    maintainers = with maintainers; [ matthiasbeyer ];
=======
    maintainers = with maintainers; [ matthiasbeyer SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
}
