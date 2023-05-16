{ lib
, fetchFromGitHub
, gobject-introspection
, gtk3
, python3
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gshogi";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "johncheetham";
    repo = "gshogi";
    rev = "v${version}";
    hash = "sha256-EPOIYPSFAhilxuZeYfuZ4Cd29ReJs/E4KNF5/lyzbxs=";
  };

  doCheck = false;  # no tests available

  buildInputs = [
    gtk3
<<<<<<< HEAD
  ];

  nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];
=======
    gobject-introspection
  ];

  nativeBuildInputs = [ wrapGAppsHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pycairo
  ];

  meta = with lib; {
    homepage = "http://johncheetham.com/projects/gshogi/";
    description = "A graphical implementation of the Shogi board game, also known as Japanese Chess";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.ciil ];
  };
}
