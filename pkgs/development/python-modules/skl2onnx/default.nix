{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  scipy,
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
  version = "1.17.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cSfchORw9In2gJTM//mlqBW2CfcA1D5wjm9lijOwZAM=";
  };

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
