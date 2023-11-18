{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, xvfb-run
, wrapGAppsHook
, gobject-introspection
, pygobject3
, graphviz
, gtk3
, numpy
}:

buildPythonPackage rec {
  pname = "xdot";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "jrfonseca";
    repo = "xdot.py";
    rev = version;
    hash = "sha256-0UfvN7z7ThlFu825h03Z5Wur9zbiUpvD5cb5gcIhQQI=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];
  propagatedBuildInputs = [
    pygobject3
    graphviz
    gtk3
    numpy
  ];
  nativeCheckInputs = [
    xvfb-run
  ];

  dontWrapGApps = true;
  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ graphviz ]})
  '';

  checkPhase = ''
    runHook preCheck

    xvfb-run -s '-screen 0 800x600x24' ${python.interpreter} test.py

    runHook postCheck
  '';

  doCheck = true;

  meta = with lib; {
    description = "An interactive viewer for graphs written in Graphviz's dot";
    homepage = "https://github.com/jrfonseca/xdot.py";
    license = licenses.lgpl3Plus;
  };
}
