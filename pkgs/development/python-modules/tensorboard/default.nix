{
  lib,
  fetchPypi,
  buildPythonPackage,

  # dependencies
  absl-py,
  google-auth-oauthlib,
  grpcio,
  markdown,
  numpy,
  protobuf,
  setuptools,
  standard-imghdr,
  tensorboard-data-server,
  tensorboard-plugin-profile,
  tensorboard-plugin-wit,
  werkzeug,
  wheel,

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
    google-auth-oauthlib
    grpcio
    markdown
    numpy
    protobuf
    setuptools
    standard-imghdr
    tensorboard-data-server
    tensorboard-plugin-profile
    tensorboard-plugin-wit
    werkzeug
    # not declared in install_requires, but used at runtime
    # https://github.com/NixOS/nixpkgs/issues/73840
    wheel
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
