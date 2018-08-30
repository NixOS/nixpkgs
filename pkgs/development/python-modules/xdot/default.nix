{ lib, buildPythonPackage, fetchPypi, isPy3k
, wrapGAppsHook, gobjectIntrospection, pygobject3, graphviz, gnome3 }:

buildPythonPackage rec {
  pname = "xdot";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01v9vmgdxz1q2m2vq2b4aqx4ycw7grc0l4is673ygvyg9rk02dx3";
  };

  disabled = !isPy3k;

  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = [ gobjectIntrospection pygobject3 graphviz gnome3.gtk ];

  meta = with lib; {
    description = "xdot.py is an interactive viewer for graphs written in Graphviz's dot";
    homepage = https://github.com/jrfonseca/xdot.py;
    license = licenses.lgpl3Plus;
  };
}
