{
  lib,
  buildPythonApplication,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  pillow,
  psutil,
  async-tkinter-loop,
  timeago,
  platformdirs,
  sv-ttk,
}:

buildPythonApplication rec {
  pname = "steamback";
  version = "0.3.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hvMPSxIfwwQqo80JCpYhcbVY4kXs5jWtjjafVSMrw6o=";
  };

  build-system = [
    setuptools-scm
    wheel
  ];

  buildInputs = [
    setuptools
    pillow
  ];

  dependencies = [
    psutil
    async-tkinter-loop
    timeago
    platformdirs
    sv-ttk
  ];

  pythonRelaxDeps = [
    "async-tkinter-loop"
    "platformdirs"
    "Pillow"
    "psutil"
  ];

  checkPhase = ''
    runHook preCheck

    $out/bin/steamback --help

    runHook postCheck
  '';

  pythonImportsCheck = [
    "steamback"
    "steamback.gui"
    "steamback.test"
    "steamback.util"
  ];

  meta = {
    description = "Decky plugin to add versioned save-game snapshots to Steam-cloud enabled games";
    mainProgram = "steamback";
    homepage = "https://github.com/geeksville/steamback";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ AngryAnt ];
  };
}
