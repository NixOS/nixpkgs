{ lib, stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "1.3.0";
  pname = "smenu";

  src = fetchFromGitHub {
    owner = "p-gen";
    repo = "smenu";
    rev = "v${version}";
    sha256 = "sha256-r2N+MmZI2KCuYarrFL2Xn5hu4FO3n5MqADRuTXMOtk0=";
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
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
    mainProgram = "smenu";
  };
}
