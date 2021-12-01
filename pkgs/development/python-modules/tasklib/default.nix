{ lib, pythonPackages, taskwarrior, writeShellScriptBin }:

with pythonPackages;

let

wsl_stub = writeShellScriptBin "wsl" "true";

in buildPythonPackage rec {
  pname = "tasklib";
  version = "2.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b523bc12893d26c8173a6b8d84b16259c9a9c5acaaf8932bc018117f907b3bc5";
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
