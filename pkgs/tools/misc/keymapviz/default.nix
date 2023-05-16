{ fetchFromGitHub, lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "keymapviz";
<<<<<<< HEAD
  version = "1.14.1";
=======
  version = "1.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "yskoht";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-eCvwgco22uPEDDsT8FfTRon1xCGy5p1PBp0pDfNprMs=";
=======
    sha256 = "sha256-I16iJ6/CrjpDOmlewIxa5Xu/b/97VNH3ATwDNi3SuP8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = with python3.pkgs; [ regex ];

  meta = with lib; {
    description = "A qmk keymap.c visualizer";
    homepage = "https://github.com/yskoht/keymapviz";
    license = licenses.mit;
    maintainers = with maintainers; [ lom ];
  };
}
