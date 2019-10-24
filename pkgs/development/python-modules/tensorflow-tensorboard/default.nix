{ stdenv, lib, fetchPypi, buildPythonPackage, isPy3k
, numpy
, werkzeug
, protobuf
, grpcio
, markdown
, futures
, absl-py
, wheel
}:

# tensorflow/tensorboard is built from a downloaded wheel, because
# https://github.com/tensorflow/tensorboard/issues/719 blocks
# buildBazelPackage.

buildPythonPackage rec {
  pname = "tensorflow-tensorboard";
  version = "2.0.0";
  format = "wheel";

  src = fetchPypi ({
    pname = "tensorboard";
    inherit version;
    format = "wheel";
  } // (if isPy3k then {
    python = "py3";
    sha256 = "0hz9nn4bbr1k5iwdrsrcdvkg36qswqdzbgsrlbkp53ddrhb9cmfk";
  } else {
    python = "py2";
    sha256 = "1r44xi5la0iawnnl1asak2j0x9zdgag17s96mp8vw4p84s18qghl";
  }));

  propagatedBuildInputs = [
    numpy
    werkzeug
    protobuf
    markdown
    grpcio absl-py
    wheel
  ] ++ lib.optional (!isPy3k) futures;

  meta = with stdenv.lib; {
    description = "TensorFlow's Visualization Toolkit";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
