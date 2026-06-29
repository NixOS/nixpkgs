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

  # tests
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tensorboard";
  version = "2.21.0";
  format = "wheel";
  __structuredAttrs = true;

  # tensorflow/tensorboard is built from a downloaded wheel, because
  # https://github.com/tensorflow/tensorboard/issues/719 blocks buildBazelPackage.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-cnkxbctr1bw5HWI96oQVMSmc3hiHMQ6BM7w0qZbTIlU=";
  };

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

  meta = {
    description = "TensorFlow's Visualization Toolkit";
    homepage = "https://www.tensorflow.org/";
    downloadPage = "https://github.com/tensorflow/tensorboard";
    changelog = "https://github.com/tensorflow/tensorboard/blob/${finalAttrs.version}/RELEASE.md";
    license = lib.licenses.asl20;
    mainProgram = "tensorboard";
    maintainers = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
