{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# tests
, ipykernel
, nbconvert
, pytestCheckHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RaYTplXhFKsnL1rxRMNR+VT92S2ym3z6buIQuCwZeeU=";
  };

  nativeCheckInputs = [
    ipykernel
    nbconvert
    typing-extensions
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "wasabi"
  ];

  meta = with lib; {
    description = "A lightweight console printing and formatting toolkit";
    homepage = "https://github.com/ines/wasabi";
    changelog = "https://github.com/ines/wasabi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
