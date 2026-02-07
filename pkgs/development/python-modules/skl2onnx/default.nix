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
  version = "1.20.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x06oJ9kroYb+ZZaV6PyYnNl7/DIO3OPTK5k2pYeNoQo=";
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
