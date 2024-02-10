{ lib
, pythonPackages
, fetchPypi
, taskwarrior
, writeShellScriptBin
}:

with pythonPackages;

let

wsl_stub = writeShellScriptBin "wsl" "true";

in buildPythonPackage rec {
  pname = "tasklib";
  version = "2.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XM1zG1JjbdEEV6i42FjLDQJv+qsePnUbr3kb+APjfXs=";
  };

  propagatedBuildInputs = [
    six
    pytz
    tzlocal
  ];

  nativeCheckInputs = [
    taskwarrior
    wsl_stub
  ];

  meta = with lib; {
    homepage = "https://github.com/robgolding/tasklib";
    description = "Library for interacting with taskwarrior databases";
    changelog = "https://github.com/GothenburgBitFactory/tasklib/releases/tag/${version}";
    maintainers = with maintainers; [ arcnmx ];
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
