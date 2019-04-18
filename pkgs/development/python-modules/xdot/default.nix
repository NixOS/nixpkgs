{ lib, buildPythonPackage, fetchPypi, isPy3k
, wrapGAppsHook, gobject-introspection, pygobject3, graphviz, gnome3, gtk3 }:

buildPythonPackage rec {
  pname = "xdot";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cr4rh7dz4dfzyxrk5pzhm0d15gkrgkfp3i5lw178xy81pc56p71";
  };

  disabled = !isPy3k;

  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = [ gobject-introspection pygobject3 graphviz gtk3 ];

  meta = with lib; {
    description = "xdot.py is an interactive viewer for graphs written in Graphviz's dot";
    homepage = https://github.com/jrfonseca/xdot.py;
    license = licenses.lgpl3Plus;
  };
}
