{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  wheel,
  pillow,
  psutil,
  async-tkinter-loop,
  timeago,
  platformdirs,
  sv-ttk,
  poetry-core,
}:

buildPythonApplication rec {
  pname = "steamback";
  version = "1.1.2-unstable-2024-08-20";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "geeksville";
    repo = "steamback";
    rev = "a4cb7c080f26830d7528ca5d37ba080c860dd040";
    hash = "sha256-R4ydFrg6xzoQ289sg+9P3CRcBw4MEiRsIHHcZeQOwXs=";
  };

  build-system = [
    setuptools-scm
    wheel
    poetry-core
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
    pillow
  ];

  pythonRelaxDeps = [
    "async-tkinter-loop"
    "platformdirs"
    "pillow"
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
