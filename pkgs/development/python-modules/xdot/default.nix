{ lib, buildPythonPackage, fetchPypi, isPy3k
, wrapGAppsHook, gobject-introspection, pygobject3, graphviz, gnome3 }:

buildPythonPackage rec {
  pname = "xdot";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18a2ri8vggaxy7im1x9hki34v519y5jy4n07zpqq5br9syb7h1ky";
  };

  disabled = !isPy3k;

  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = [ gobject-introspection pygobject3 graphviz gnome3.gtk ];

  meta = with lib; {
    description = "xdot.py is an interactive viewer for graphs written in Graphviz's dot";
    homepage = https://github.com/jrfonseca/xdot.py;
    license = licenses.lgpl3Plus;
  };
}
