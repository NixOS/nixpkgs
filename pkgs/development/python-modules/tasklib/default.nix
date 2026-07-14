{
  lib,
  buildPythonPackage,
  six,
  pytz,
  tzlocal,
  fetchPypi,
  taskwarrior2,
  writeShellScriptBin,
}:

buildPythonPackage rec {
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
    taskwarrior2
    # stub
    (writeShellScriptBin "wsl" "true")
  ];

  meta = {
    homepage = "https://github.com/robgolding/tasklib";
    description = "Library for interacting with taskwarrior databases";
    changelog = "https://github.com/GothenburgBitFactory/tasklib/releases/tag/${version}";
    maintainers = with lib.maintainers; [ arcnmx ];
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
  };
}
