{ lib
, buildPythonPackage
, fetchPypi
, importlib-resources
, pytest-subtests
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tzdata";
  version = "2022.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i1NqjsY9wHUTQrOYQZOjEY+Pyir+JXUrubf//TmFUtM=";
  };

  checkInputs = [
    pytestCheckHook
    pytest-subtests
  ] ++ lib.optional (pythonOlder "3.7") [
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
