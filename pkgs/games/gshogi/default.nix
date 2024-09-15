{ lib
, fetchFromGitHub
, gobject-introspection
, gtk3
, python3
, wrapGAppsHook3
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
  ];

  nativeBuildInputs = [ wrapGAppsHook3 gobject-introspection ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pycairo
  ];

  meta = with lib; {
    homepage = "http://johncheetham.com/projects/gshogi/";
    description = "Graphical implementation of the Shogi board game, also known as Japanese Chess";
    mainProgram = "gshogi";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.ciil ];
  };
}
