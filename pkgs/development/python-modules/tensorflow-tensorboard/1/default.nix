{ lib, fetchPypi, buildPythonPackage, isPy3k
, numpy
, wheel
, werkzeug
, protobuf
, grpcio
, markdown
, futures
, absl-py
}:

# tensorflow/tensorboard is built from a downloaded wheel, because
# https://github.com/tensorflow/tensorboard/issues/719 blocks
# buildBazelPackage.

buildPythonPackage rec {
  pname = "tensorflow-tensorboard";
  version = "1.15.0";
  format = "wheel";

  src = fetchPypi ({
    pname = "tensorboard";
    inherit version format;
  } // (if isPy3k then {
    python = "py3";
    sha256 = "1g62i3nrgp8q9wfsyqqjkkfnsz7x2k018c26kdh527h1yrjjrbac";
  } else {
    python = "py2";
    sha256 = "0l3zc8j2sh7h1z4qpy8kfvclv3kzndri55p10i42q6xahs9phav1";
  }));

  propagatedBuildInputs = [
    numpy
    werkzeug
    protobuf
    markdown
    grpcio
    absl-py
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
