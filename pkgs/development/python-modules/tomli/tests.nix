{ buildPythonPackage
, tomli
, pytestCheckHook
, python-dateutil
}:

buildPythonPackage rec {
  pname = "tomli-tests";
  inherit (tomli) version;

  src = tomli.testsout;

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    pytestCheckHook
    python-dateutil
    tomli
  ];
}
