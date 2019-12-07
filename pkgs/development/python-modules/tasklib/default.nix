{ lib, pythonPackages, taskwarrior, writeShellScriptBin }:

with pythonPackages;

let

wsl_stub = writeShellScriptBin "wsl" "true";

in buildPythonPackage rec {
  pname = "tasklib";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19yra86g3wz2xgk22dnrjjh3gla969vb8jrps5rf0cdmsm9qqisv";
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
    homepage = https://github.com/robgolding/tasklib;
    description = "A library for interacting with taskwarrior databases";
    maintainers = with maintainers; [ arcnmx ];
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
