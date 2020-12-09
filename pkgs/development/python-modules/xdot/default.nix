{ lib, buildPythonPackage, fetchPypi, isPy3k
, wrapGAppsHook, gobject-introspection, pygobject3, graphviz, gtk3 }:

buildPythonPackage rec {
  pname = "xdot";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3df91e6c671869bd2a6b2a8883fa3476dbe2ba763bd2a7646cf848a9eba71b70";
  };

  disabled = !isPy3k;

  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = [ gobject-introspection pygobject3 graphviz gtk3 ];

  meta = with lib; {
    description = "An interactive viewer for graphs written in Graphviz's dot";
    homepage = "https://github.com/jrfonseca/xdot.py";
    license = licenses.lgpl3Plus;
  };
}
