{
  lib,
  buildPythonPackage,
  fetchPypi,

  # nativeBuildInputs

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  asyncssh,
  atomicwrites,
  chardet,
  cloudpickle,
  cookiecutter,
  diff-match-patch,
  fzf,
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
  pygithub,
  pygments,
  pylint-venv,
  pyls-spyder,
  pyopengl,
  pyqtwebengine,
  python-lsp-black,
  python-lsp-server,
  pyuca,
  pyzmq,
  qdarkstyle,
  qstylizer,
  qtawesome,
  qtconsole,
  qtpy,
  rope,
  rtree,
  scipy,
  spyder-kernels,
  superqt,
  textdistance,
  three-merge,
  watchdog,
  yarl,
}:

buildPythonPackage rec {
  pname = "spyder";
  version = "6.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g4cyG5OQ180K9NzPRO/yH3CY5kQDS/g+fp5qCa/YDA8=";
  };

  patches = [ ./dont-clear-pythonpath.patch ];

  nativeBuildInputs = [
    pyqtwebengine.wrapQtAppsHook
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    asyncssh
    atomicwrites
    chardet
    cloudpickle
    cookiecutter
    diff-match-patch
    fzf
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
    pygithub
    pygments
    pylint-venv
    pyls-spyder
    pyopengl
    pyqtwebengine
    python-lsp-black
    python-lsp-server
    pyuca
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
    superqt
    textdistance
    three-merge
    watchdog
    yarl
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
