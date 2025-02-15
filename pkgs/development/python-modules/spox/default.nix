{ lib
, buildPythonPackage
, python3Packages
, fetchPypi
 }:

buildPythonPackage rec {
  pname = "spox";
  version = "0.10.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VfxyIRN8nNNEda7zPPRbYKfC7fXV6K45eYsT6vngmWk=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    numpy
    onnx
    packaging
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    onnxruntime
  ];

  meta = with lib; {
    changelog = "https://github.com/Quantco/spox/releases/tag/${version}";
    description = "Pythonic framework for building ONNX graphs";
    homepage = "https://github.com/Quantco/spox";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cbourjau ];
  };
}
