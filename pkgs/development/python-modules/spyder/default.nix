{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  atomicwrites,
  chardet,
  cloudpickle,
  cookiecutter,
  diff-match-patch,
  intervaltree,
  jedi,
  jellyfish,
  keyring,
  matplotlib,
  nbconvert,
  numpy,
  numpydoc,
  pickleshare,
  psutil,
  pygments,
  pylint-venv,
  pyls-spyder,
  pyopengl,
  pyqtwebengine,
  python-lsp-black,
  python-lsp-server,
  pyxdg,
  pyzmq,
  qdarkstyle,
  qstylizer,
  qtawesome,
  qtconsole,
  qtpy,
  rope,
  rtree,
  scipy,
  setuptools,
  spyder-kernels,
  textdistance,
  three-merge,
  watchdog,
}:

buildPythonPackage rec {
  pname = "spyder";
  version = "5.5.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UiIyoFREfd3gV0uhSgZ8TVFQiP3yprrBZDOm3+8Dge0=";
  };

  patches = [ ./dont-clear-pythonpath.patch ];

  build-system = [
    pyqtwebengine.wrapQtAppsHook
    setuptools
  ];

  dependencies = [
    atomicwrites
    chardet
    cloudpickle
    cookiecutter
    diff-match-patch
    intervaltree
    jedi
    jellyfish
    keyring
    matplotlib
    nbconvert
    numpy
    numpydoc
    pickleshare
    psutil
    pygments
    pylint-venv
    pyls-spyder
    pyopengl
    pyqtwebengine
    python-lsp-black
    python-lsp-server
    pyxdg
    pyzmq
    qdarkstyle
    qstylizer
    qtawesome
    qtconsole
    qtpy
    rope
    rtree
    scipy
    spyder-kernels
    textdistance
    three-merge
    watchdog
  ] ++ python-lsp-server.optional-dependencies.all;

  # There is no test for spyder
  doCheck = false;

  postPatch = ''
    # Remove dependency on pyqtwebengine
    # This is still part of the pyqt 5.11 version we have in nixpkgs
    sed -i /pyqtwebengine/d setup.py
    substituteInPlace setup.py \
      --replace "qdarkstyle>=3.0.2,<3.1.0" "qdarkstyle" \
      --replace "ipython>=7.31.1,<8.0.0" "ipython"
  '';

  postInstall = ''
    # Add Python libs to env so Spyder subprocesses
    # created to run compute kernels don't fail with ImportErrors
    wrapProgram $out/bin/spyder --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Scientific python development environment";
    mainProgram = "spyder";
    longDescription = ''
      Spyder (previously known as Pydee) is a powerful interactive development
      environment for the Python language with advanced editing, interactive
      testing, debugging and introspection features.
    '';
    homepage = "https://www.spyder-ide.org/";
    downloadPage = "https://github.com/spyder-ide/spyder/releases";
    changelog = "https://github.com/spyder-ide/spyder/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.linux;
  };
}
