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
  version = "1.14.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gF+XOgAILSlM+hU1s3Xz+zD7nPtwW9a0mOHp8rxthnY=";
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
