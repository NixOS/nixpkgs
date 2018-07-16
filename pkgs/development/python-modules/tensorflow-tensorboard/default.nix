{ stdenv, lib, fetchPypi, buildPythonPackage, isPy3k
, bleach_1_5_0
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
  version = "1.7.0";
  format = "wheel";

  src = fetchPypi ({
    pname = "tensorboard";
    inherit version;
    format = "wheel";
  } // (if isPy3k then {
    python = "py3";
    sha256 = "1aa42rl3fkpllqch09d311gk1j281qry6nn07ywgbs6j0kwr6isc";
  } else {
    python = "py2";
    sha256 = "1vcdkyvw22kpljmj4gxb8m1q54ry02iwvw54w8v8hmdigvc77a7k";
  }));

  propagatedBuildInputs = [ bleach_1_5_0 numpy werkzeug protobuf markdown grpcio ] ++ lib.optional (!isPy3k) futures;

  meta = with stdenv.lib; {
    description = "TensorFlow's Visualization Toolkit";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
