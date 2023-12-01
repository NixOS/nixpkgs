{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, pythonRelaxDepsHook
, numpy
, wheel
, werkzeug
, protobuf
, grpcio
, markdown
, absl-py
, google-auth-oauthlib
, setuptools
, tensorboard-data-server
, tensorboard-plugin-wit
, tensorboard-plugin-profile
}:

# tensorflow/tensorboard is built from a downloaded wheel, because
# https://github.com/tensorflow/tensorboard/issues/719 blocks
# buildBazelPackage.

buildPythonPackage rec {
  pname = "tensorboard";
  version = "2.14.0";
  format = "wheel";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-Nmf5dF2ZKAg2rWcwIjYshA9g7Y/v1aPjC/Bx9aj9ABc=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "google-auth-oauthlib"
    "protobuf"
  ];

  propagatedBuildInputs = [
    absl-py
    grpcio
    google-auth-oauthlib
    markdown
    numpy
    protobuf
    setuptools
    tensorboard-data-server
    tensorboard-plugin-profile
    tensorboard-plugin-wit
    werkzeug
    # not declared in install_requires, but used at runtime
    # https://github.com/NixOS/nixpkgs/issues/73840
    wheel
  ];

  # in the absence of a real test suite, run cli and imports
  checkPhase = ''
    $out/bin/tensorboard --help > /dev/null
  '';

  pythonImportsCheck = [
    "tensorboard"
    "tensorboard.backend"
    "tensorboard.compat"
    "tensorboard.data"
    "tensorboard.plugins"
    "tensorboard.summary"
    "tensorboard.util"
  ];

  meta = with lib; {
    description = "TensorFlow's Visualization Toolkit";
    homepage = "https://www.tensorflow.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
