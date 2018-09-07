{ stdenv, lib, fetchPypi, buildPythonPackage, isPy3k
, numpy
, werkzeug
, protobuf
, grpcio
, markdown
, futures
}:

# tensorflow/tensorboard is built from a downloaded wheel, because
# https://github.com/tensorflow/tensorboard/issues/719 blocks
# buildBazelPackage.

buildPythonPackage rec {
  pname = "tensorflow-tensorboard";
  version = "1.9.0";
  format = "wheel";

  src = fetchPypi ({
    pname = "tensorboard";
    inherit version;
    format = "wheel";
  } // (if isPy3k then {
    python = "py3";
    sha256 = "42a04637a636e16054b065907c81396b83a9702948ecd14218f19dc5cf85de98";
  } else {
    python = "py2";
    sha256 = "97661706fbe857c372405e0f5bd7c3db2197b5e70cec88f6924b726fde65c2c1";
  }));

  propagatedBuildInputs = [ numpy werkzeug protobuf markdown grpcio ] ++ lib.optional (!isPy3k) futures;

  meta = with stdenv.lib; {
    description = "TensorFlow's Visualization Toolkit";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
