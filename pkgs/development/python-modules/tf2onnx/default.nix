{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  flatbuffers,
  numpy,
  onnx,
  onnxruntime,
  protobuf,
  requests,
  six,
  tensorflow,
}:

buildPythonPackage rec {
  pname = "tf2onnx";
  version = "1.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "tensorflow-onnx";
    tag = "v${version}";
    hash = "sha256-qtRzckw/KHWm3gjFwF+cPuBhGbfktjhYIwImwHn2CFk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'" ""
  '';

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    flatbuffers
    numpy
    onnx
    onnxruntime
    protobuf
    requests
    six
    tensorflow
  ];

  pythonImportsCheck = [ "tf2onnx" ];

  # All tests fail at import with:
  # AttributeError: `...` is not available with Keras 3.
  doCheck = false;

  meta = {
    description = "Convert TensorFlow, Keras, Tensorflow.js and Tflite models to ONNX";
    homepage = "https://github.com/onnx/tensorflow-onnx";
    changelog = "https://github.com/onnx/tensorflow-onnx/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
