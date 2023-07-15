{ lib
, buildPythonApplication
, fetchPypi
, pythonRelaxDepsHook
, setuptools
, pillow
, psutil
, async-tkinter-loop
, timeago
, platformdirs
, sv-ttk
}:

buildPythonApplication rec {
  pname = "steamback";
  version = "0.3.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hvMPSxIfwwQqo80JCpYhcbVY4kXs5jWtjjafVSMrw6o=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  buildInputs = [
    setuptools
    pillow
  ];

  propagatedBuildInputs = [
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
  ];

  checkPhase = ''
    runHook preCheck

    $out/bin/${pname} --help

    runHook postCheck
  '';

  meta = with lib; {
    description = "A Decky plugin to add versioned save-game snapshots to Steam-cloud enabled games";
    homepage = "https://github.com/geeksville/steamback";
    license = licenses.gpl3;
    maintainers = with maintainers; [ AngryAnt ];
  };
}
