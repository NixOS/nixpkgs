{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonRelaxDepsHook
, pytest-runner
# runtime dependencies
, numpy
, onnx
, requests
, six
, flatbuffers
, protobuf
, tensorflow
# check dependencies
, pytestCheckHook
, graphviz
, parameterized
, pytest-cov
, pyyaml
, timeout-decorator
, onnxruntime
, keras
}:

buildPythonPackage rec {
  pname = "tf2onnx";
  version = "1.15.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "tensorflow-onnx";
    rev = "refs/tags/v${version}";
    hash = "sha256-HqzcoPPX9+NOj0uFfOSVI2MNCkxq1NmLqXflwdi5RF0=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    pytest-runner
  ];

  pythonRelaxDeps = [
    "flatbuffers"
  ];

  propagatedBuildInputs = [
    numpy
    onnx
    requests
    six
    flatbuffers
    protobuf
    tensorflow
    onnxruntime
  ];

  pythonImportsCheck = [ "tf2onnx" ];

  nativeCheckInputs = [
    pytestCheckHook
    graphviz
    parameterized
    pytest-cov
    pyyaml
    timeout-decorator
    keras
  ];

  # TODO investigate the failures
  disabledTestPaths = [
    "tests/test_backend.py"
    "tests/test_einsum_helper.py"
    "tests/test_einsum_optimizers.py"
  ];

  disabledTests = [
    "test_profile_conversion_time"
  ];

  meta = with lib; {
    description = "Convert TensorFlow, Keras, Tensorflow.js and Tflite models to ONNX";
    homepage = "https://github.com/onnx/tensorflow-onnx";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
