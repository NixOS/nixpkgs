{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, wrapGAppsHook, gobject-introspection, pygobject3, graphviz, gtk3
, numpy, pytestCheckHook }:

buildPythonPackage rec {
  pname = "xdot";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "jrfonseca";
    repo = "xdot.py";
    rev = version;
    sha256 = "0lignsx7yr2pq92q8dgyim7d3xlmmwq1l16waz3qj4p6g2yh8023";
  };

  disabled = !isPy3k;

  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = [ numpy gobject-introspection pygobject3 graphviz gtk3 ];
  checkPhase = ''
    python ./test.py;
  '';

  meta = with lib; {
    description = "An interactive viewer for graphs written in Graphviz's dot";
    homepage = "https://github.com/jrfonseca/xdot.py";
    license = licenses.lgpl3Plus;
  };
}
