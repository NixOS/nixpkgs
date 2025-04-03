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
  protobuf,
  setuptools,
  six,
  tensorboard-data-server,
  werkzeug,
  standard-imghdr,

  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "tensorboard";
  version = "2.19.0";
  format = "wheel";

  # tensorflow/tensorboard is built from a downloaded wheel, because
  # https://github.com/tensorflow/tensorboard/issues/719 blocks buildBazelPackage.
  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-XnG5hmOmQafOim5wsL6OGkwMRdSHYLB2ODrEdVw1uaA=";
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
    protobuf
    setuptools
    six
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
    maintainers = with lib.maintainers; [ abbradar ];
  };
}
