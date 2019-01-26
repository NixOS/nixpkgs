{ stdenv, buildPythonApplication, fetchFromGitHub
, gtk3, gobject-introspection
, wrapGAppsHook, python3Packages }:

buildPythonApplication rec {
  pname = "gshogi";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "johncheetham";
    repo = "gshogi";
    rev = "v${version}";
    sha256 = "06vgndfgwyfi50wg3cw92zspc9z0k7xn2pp6qsjih0l5yih8iwqh";
  };

  doCheck = false;  # no tests available

  buildInputs = [
    gtk3
    gobject-introspection
  ];

  nativeBuildInputs = [ wrapGAppsHook ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pycairo
  ];

  meta = with stdenv.lib; {
    description = "A graphical implementation of the Shogi board game, also known as Japanese Chess";
    homepage = http://johncheetham.com/projects/gshogi/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.ciil ];
  };
}
