{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  scipy,
  setuptools,
  protobuf,
  onnx,
  scikit-learn,
  onnxconverter-common,
  onnxruntime,
  pandas,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "skl2onnx";
  version = "1.19.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DBBfKjuHpiTdIY0fuY/dGc8b9iFxkNJc5+FUhBJ9Dl0=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    scipy
    protobuf
    onnx
    scikit-learn
    onnxconverter-common
  ];

  pythonRelaxDeps = [ "scikit-learn" ];

  nativeCheckInputs = [
    onnxruntime
    pandas
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  # Core dump
  doCheck = false;

  meta = {
    description = "Convert scikit-learn models to ONNX";
    license = with lib.licenses; [ asl20 ];
  };
}
