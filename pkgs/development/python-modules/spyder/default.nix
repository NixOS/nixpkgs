{
  lib,
  buildPythonPackage,
  fetchPypi,

  # nativeBuildInputs
  pyqtwebengine,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  asyncssh,
  atomicwrites,
  bcrypt,
  chardet,
  cloudpickle,
  cookiecutter,
  diff-match-patch,
  fzf,
  intervaltree,
  ipython-pygments-lexers,
  jedi,
  jellyfish,
  keyring,
  matplotlib,
  nbconvert,
  numpy,
  numpydoc,
  packaging,
  pickleshare,
  psutil,
  pygithub,
  pygments,
  pylint-venv,
  pyls-spyder,
  pyopengl,
  python-lsp-black,
  python-lsp-ruff,
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
<<<<<<< HEAD
  version = "6.1.2";
=======
  version = "6.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-bgkiihfqqIHnYes5gvIvAdQ7arUAm7NmGLaqnP/Ml40=";
=======
    hash = "sha256-swpIjmkrEljaPc2eA7YbXwXRuq2mOvga6Zm8v4acYU4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [ ./dont-clear-pythonpath.patch ];

  nativeBuildInputs = [ pyqtwebengine.wrapQtAppsHook ];

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "ipython"
    "python-lsp-server"
  ];

  dependencies = [
    aiohttp
    asyncssh
    atomicwrites
    bcrypt
    chardet
    cloudpickle
    cookiecutter
    diff-match-patch
    fzf
    intervaltree
    ipython-pygments-lexers
    jedi
    jellyfish
    keyring
    matplotlib
    nbconvert
    numpy
    numpydoc
    packaging
    pickleshare
    psutil
    pygithub
    pygments
    pylint-venv
    pyls-spyder
    pyopengl
    pyqtwebengine
    python-lsp-black
    python-lsp-ruff
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
  ]
  ++ python-lsp-server.optional-dependencies.all;

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
    changelog = "https://github.com/spyder-ide/spyder/blob/v${version}/changelogs/Spyder-6.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
