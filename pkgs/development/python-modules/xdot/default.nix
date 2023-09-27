{ lib, buildPythonPackage, fetchPypi, isPy3k, python, xvfb-run
, wrapGAppsHook, gobject-introspection, pygobject3, graphviz, gtk3, numpy }:

buildPythonPackage rec {
  pname = "xdot";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FtyvfAY8x/smpSkKDRZgawPeF4plNePUndFnCbZCBoE=";
  };

  disabled = !isPy3k;
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
  propagatedBuildInputs = [ pygobject3 graphviz gtk3 numpy ];
  nativeCheckInputs = [ xvfb-run ];

  postInstall = ''
    wrapProgram "$out/bin/xdot" --prefix PATH : "${lib.makeBinPath [ graphviz ]}"
  '';

  checkPhase = ''
    xvfb-run -s '-screen 0 800x600x24' ${python.interpreter} nix_run_setup test
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
