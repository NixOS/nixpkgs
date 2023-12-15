{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, protobuf
, onnx
, scikit-learn
, onnxconverter-common
, onnxruntime
, pandas
, unittestCheckHook
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "skl2onnx";
  version = "1.15.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BbLCZDrQNX7B6mhNE4Q4ot9lffgo5X0Hy3jC52viDjc=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    protobuf
    onnx
    scikit-learn
    onnxconverter-common
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "scikit-learn" ];

  nativeCheckInputs = [
    onnxruntime
    pandas
    unittestCheckHook
  ];

  unittestFlagsArray = [ "-s" "tests" ];

  # Core dump
  doCheck = false;

  meta = {
    description = "Convert scikit-learn models to ONNX";
    maintainers = with lib.maintainers; [ fridh ];
    license = with lib.licenses; [ asl20 ];
  };
}
