{ stdenv, lib, fetchPypi, buildPythonPackage, isPy3k
, bleach_1_5_0
, numpy
, werkzeug
, protobuf
, markdown
, futures
}:

# tensorflow is built from a downloaded wheel, because
# https://github.com/tensorflow/tensorboard/issues/719
# blocks buildBazelPackage.

buildPythonPackage rec {
  pname = "tensorflow-tensorboard";
  version = "1.5.1";
  name = "${pname}-${version}";
  format = "wheel";

  src = fetchPypi ({
    pname = "tensorflow_tensorboard";
    inherit version;
    format = "wheel";
  } // (if isPy3k then {
    python = "py3";
    sha256 = "1cydgvrr0s05xqz1v9z2wdiv60gzbs8wv9wvbflw5700a2llb63l";
  } else {
    python = "py2";
    sha256 = "0dhljddlirq6nr84zg4yrk5k69gj3x2abb6wg3crgrparb6qbya7";
  }));

  propagatedBuildInputs = [ bleach_1_5_0 numpy werkzeug protobuf markdown ] ++ lib.optional (!isPy3k) futures;

  meta = with stdenv.lib; {
    description = "TensorFlow's Visualization Toolkit";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
