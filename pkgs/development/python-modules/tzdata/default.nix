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
  version = "2022.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IfTw1yQVcu+n96T9q7BS5htV3EgnTmhCaXzN9SU+VFE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
