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
, tensorboard-plugin-wit
}:

# tensorflow/tensorboard is built from a downloaded wheel, because
# https://github.com/tensorflow/tensorboard/issues/719 blocks
# buildBazelPackage.

buildPythonPackage rec {
  pname = "tensorflow-tensorboard";
  version = "2.2.0";
  format = "wheel";

  disabled = ! isPy3k; # Python 2 not supported any more in version 2.2

  src = fetchPypi {
    pname = "tensorboard";
    inherit version;
    format = "wheel";
    python = "py3";
    sha256 = "1vdsgmr9i0nshcg884bfhr4rz5vnf90y8jdxdjx1319dmmsvqsxv";
  };

  propagatedBuildInputs = [
    numpy
    werkzeug
    protobuf
    markdown
    grpcio
    absl-py
    google-auth-oauthlib
    tensorboard-plugin-wit
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
    homepage = "http://tensorflow.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
