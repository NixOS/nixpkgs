{ lib, fetchPypi, buildPythonPackage, isPy3k
, numpy
, wheel
, werkzeug
, protobuf
, grpcio
, markdown
, futures
, absl-py
, google-auth-oauthlib
}:

# tensorflow/tensorboard is built from a downloaded wheel, because
# https://github.com/tensorflow/tensorboard/issues/719 blocks
# buildBazelPackage.

buildPythonPackage rec {
  pname = "tensorflow-tensorboard";
  version = "2.1.0";
  format = "wheel";

  src = fetchPypi ({
    pname = "tensorboard";
    inherit version;
    format = "wheel";
  } // (if isPy3k then {
    python = "py3";
    sha256 = "1wpjdzhjpcdkyaahzd4bl71k4l30z5c55280ndiwj32hw70lxrp6";
  } else {
    python = "py2";
    sha256 = "1f805839xa36wxb7xac9fyxzaww92vw4d50vs6g61wnlr4byp00w";
  }));

  propagatedBuildInputs = [
    numpy
    werkzeug
    protobuf
    markdown
    grpcio
    absl-py
    google-auth-oauthlib
    # not declared in install_requires, but used at runtime
    # https://github.com/NixOS/nixpkgs/issues/73840
    wheel
  ] ++ lib.optional (!isPy3k) futures;

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
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
