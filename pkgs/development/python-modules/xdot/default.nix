{ lib, buildPythonPackage, fetchPypi, isPy3k, python3, xvfb_run
, wrapGAppsHook, gobject-introspection, pygobject3, graphviz, gtk3, numpy }:

buildPythonPackage rec {
  pname = "xdot";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3df91e6c671869bd2a6b2a8883fa3476dbe2ba763bd2a7646cf848a9eba71b70";
  };

  disabled = !isPy3k;
  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = [ gobject-introspection pygobject3 graphviz gtk3 numpy ];
  checkInputs = [ xvfb_run ];

  checkPhase = ''
    xvfb-run -s '-screen 0 800x600x24' ${python3.interpreter} nix_run_setup test
  '';

  # https://github.com/NixOS/nixpkgs/pull/107872#issuecomment-752175866
  # cannot import name '_gi' from partially initialized module 'gi' (most likely due to a circular import)
  doCheck = false;

  meta = with lib; {
    description = "An interactive viewer for graphs written in Graphviz's dot";
    homepage = "https://github.com/jrfonseca/xdot.py";
    license = licenses.lgpl3Plus;
  };
}
