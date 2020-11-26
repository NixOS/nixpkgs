{ lib, pythonPackages, taskwarrior, writeShellScriptBin }:

with pythonPackages;

let

wsl_stub = writeShellScriptBin "wsl" "true";

in buildPythonPackage rec {
  pname = "tasklib";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21525a34469928876b64edf8abf79cf788bb3fa796d4554ba22a68bc1f0693f5";
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
