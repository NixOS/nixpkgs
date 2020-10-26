{ lib, pythonPackages, taskwarrior, writeShellScriptBin, isPy27 }:

with pythonPackages;

let

wsl_stub = writeShellScriptBin "wsl" "true";

in buildPythonPackage rec {
  pname = "tasklib";
  version = "2.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "da66e84614b09443aa67c4dc2922213417329c39511dc5b384d8a5671e29115e";
  };

  propagatedBuildInputs = [
    six
    pytz
    tzlocal
  ];

  checkInputs = [
    taskwarrior
    wsl_stub
  ];

  meta = with lib; {
    homepage = "https://github.com/robgolding/tasklib";
    description = "A library for interacting with taskwarrior databases";
    maintainers = with maintainers; [ arcnmx ];
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
