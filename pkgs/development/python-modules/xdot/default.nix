{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  xvfb-run,
  wrapGAppsHook3,
  gobject-introspection,
  pygobject3,
  graphviz,
  gtk3,
  numpy,
  packaging,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xdot";
<<<<<<< HEAD
  version = "1.6";
=======
  version = "1.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jrfonseca";
    repo = "xdot.py";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-eOuD8q7qN2MAFklIy28lfR0nEMsKDqVO+HE3+M0k5T0=";
=======
    hash = "sha256-fkO1bINRkCCzVRrQg9+vIODbN+bpXq2OHBKkzzZUZNA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    graphviz
    gtk3
  ];

  dependencies = [
    pygobject3
    numpy
    packaging
  ];
  nativeCheckInputs = [ xvfb-run ];

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

<<<<<<< HEAD
  meta = {
    description = "Interactive viewer for graphs written in Graphviz's dot";
    mainProgram = "xdot";
    homepage = "https://github.com/jrfonseca/xdot.py";
    license = lib.licenses.lgpl3Plus;
=======
  meta = with lib; {
    description = "Interactive viewer for graphs written in Graphviz's dot";
    mainProgram = "xdot";
    homepage = "https://github.com/jrfonseca/xdot.py";
    license = licenses.lgpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
