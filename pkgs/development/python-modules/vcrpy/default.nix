{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytest-httpbin
, pytestCheckHook
, pythonOlder
, pyyaml
, six
, yarl
, wrapt
}:

buildPythonPackage rec {
  pname = "vcrpy";
  version = "4.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fNPoGixJLgHCgfGAvMKoa1ILFz0rZWy12J2ZR1Qj4BM=";
  };

  propagatedBuildInputs = [
    pyyaml
    six
    yarl
    wrapt
  ];

  nativeCheckInputs = [
    pytest-httpbin
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/integration"
  ];

  disabledTests = [
    "TestVCRConnection"
  ];

  pythonImportsCheck = [
    "vcr"
  ];

  meta = with lib; {
    description = "Automatically mock your HTTP interactions to simplify and speed up testing";
    homepage = "https://github.com/kevin1024/vcrpy";
    changelog = "https://github.com/kevin1024/vcrpy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
