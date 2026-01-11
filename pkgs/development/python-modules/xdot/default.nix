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
  version = "1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jrfonseca";
    repo = "xdot.py";
    rev = version;
    hash = "sha256-eOuD8q7qN2MAFklIy28lfR0nEMsKDqVO+HE3+M0k5T0=";
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

  meta = {
    description = "Interactive viewer for graphs written in Graphviz's dot";
    mainProgram = "xdot";
    homepage = "https://github.com/jrfonseca/xdot.py";
    license = lib.licenses.lgpl3Plus;
  };
}
