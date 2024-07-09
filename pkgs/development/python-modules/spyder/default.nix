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
  version = "5.5.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y+JZO/LfWi1QzoSSV1uDI4zxLcte0HwVMNmBK0aXgd4=";
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

  postInstall = ''
    # Add Python libs to env so Spyder subprocesses
    # created to run compute kernels don't fail with ImportErrors
    wrapProgram $out/bin/spyder --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gebner ];
    platforms = lib.platforms.linux;
  };
}
