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
  version = "2021.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aNvkGv0BuGeJS739VPoD9GjPpPAIa/tK3NjejyTz7iE=";
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
