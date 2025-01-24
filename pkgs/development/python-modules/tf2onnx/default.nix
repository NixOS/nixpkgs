{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # runtime dependencies
  numpy,
  onnx,
  requests,
  six,
  flatbuffers,
  protobuf,
  tensorflow,
  # check dependencies
  pytestCheckHook,
  graphviz,
  parameterized,
  pytest-cov-stub,
  pyyaml,
  timeout-decorator,
  onnxruntime,
  keras,
}:

buildPythonPackage rec {
  pname = "tf2onnx";
  version = "1.16.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "tensorflow-onnx";
    rev = "refs/tags/v${version}";
    hash = "sha256-qtRzckw/KHWm3gjFwF+cPuBhGbfktjhYIwImwHn2CFk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'" ""
  '';

  pythonRelaxDeps = [ "flatbuffers" ];

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
    pytest-cov-stub
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

  disabledTests = [ "test_profile_conversion_time" ];

  meta = with lib; {
    description = "Convert TensorFlow, Keras, Tensorflow.js and Tflite models to ONNX";
    homepage = "https://github.com/onnx/tensorflow-onnx";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    # Duplicated `protobuf` in the derivation:
    # - version 4.24.4 (from onnx), the default version of protobuf in nixpkgs
    # - version 4.21.12 (from tensorflow), pinned as such because tensorflow is outdated and does
    #   not support more recent versions of protobuf
    broken = true;
  };
}
