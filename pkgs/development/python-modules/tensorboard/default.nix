{
  lib,
  fetchPypi,
  buildPythonPackage,

  # dependencies
  absl-py,
  grpcio,
  markdown,
  numpy,
  packaging,
  pillow,
  protobuf,
  setuptools,
  tensorboard-data-server,
  werkzeug,
  standard-imghdr,

  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "tensorboard";
  version = "2.20.0";
  format = "wheel";

  # tensorflow/tensorboard is built from a downloaded wheel, because
  # https://github.com/tensorflow/tensorboard/issues/719 blocks buildBazelPackage.
  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-ncn5eMuEwHI6z5o0XZbBhPApPRjxZruNWe4Jjmz6q6Y=";
  };

  pythonRelaxDeps = [
    "google-auth-oauthlib"
    "protobuf"
  ];

  dependencies = [
    absl-py
    grpcio
    markdown
    numpy
    packaging
    pillow
    protobuf
    setuptools
    tensorboard-data-server
    werkzeug

    # Requires 'imghdr' which has been removed from python in 3.13
    # ModuleNotFoundError: No module named 'imghdr'
    # https://github.com/tensorflow/tensorboard/issues/6964
    standard-imghdr
  ];

  pythonImportsCheck = [
    "tensorboard"
    "tensorboard.backend"
    "tensorboard.compat"
    "tensorboard.data"
    "tensorboard.plugins"
    "tensorboard.summary"
    "tensorboard.util"
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/tensorflow/tensorboard/blob/${version}/RELEASE.md";
    description = "TensorFlow's Visualization Toolkit";
    homepage = "https://www.tensorflow.org/";
    license = lib.licenses.asl20;
    mainProgram = "tensorboard";
    maintainers = [ ];
  };
}
