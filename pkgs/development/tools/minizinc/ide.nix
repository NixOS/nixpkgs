{ lib, mkDerivation, fetchFromGitHub, qtbase, qtwebengine, qtwebkit, qmake, minizinc }:
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
mkDerivation rec {
  pname = "minizinc-ide";
  version = "2.5.5";

<<<<<<< HEAD
=======
  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtwebengine qtwebkit ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "MiniZincIDE";
    rev = version;
    sha256 = "sha256-0U3KFRDam8psbCaEOcrwqzICAy1oBgo8SFEiR/PMqZk=";
    fetchSubmodules = true;
  };

<<<<<<< HEAD
  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtwebengine qtwebkit ];

  sourceRoot = "${src.name}/MiniZincIDE";
=======
  sourceRoot = "source/MiniZincIDE";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dontWrapQtApps = true;

  postInstall = ''
    wrapProgram $out/bin/MiniZincIDE --prefix PATH ":" ${lib.makeBinPath [ minizinc ]}
  '';

  meta = with lib; {
    homepage = "https://www.minizinc.org/";
    description = "IDE for MiniZinc, a medium-level constraint modelling language";
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.dtzWill ];
  };
}
