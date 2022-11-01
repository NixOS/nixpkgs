{ lib
, buildPythonPackage
, fetchPypi
, importlib-resources
, pytest-subtests
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "tzdata";
  version = "2022.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kfEdtFAzhZKMFVmMmFc+OvB+cikYG+5Tdb0w8Wld3K4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
    pytest-subtests
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-resources
  ];

  pythonImportsCheck = [
    "tzdata"
  ];

  meta = with lib; {
    description = "Provider of IANA time zone data";
    homepage = "https://github.com/python/tzdata";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
