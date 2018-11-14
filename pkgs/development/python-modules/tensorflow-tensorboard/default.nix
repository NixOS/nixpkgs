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
  version = "1.11.0";
  format = "wheel";

  src = fetchPypi ({
    pname = "tensorboard";
    inherit version;
    format = "wheel";
  } // (if isPy3k then {
    python = "py3";
    sha256 = "1nkd37zq9mk0gc9x6d4x8whahbx2cn0wl94lir3g1pibdzx9hc4v";
  } else {
    python = "py2";
    sha256 = "1mkyb5gn952i4s7fmc9ay4yh74ysrqbiqna6dl1qmahjpbaavbf5";
  }));

  propagatedBuildInputs = [ numpy werkzeug protobuf markdown grpcio ] ++ lib.optional (!isPy3k) futures;

  meta = with stdenv.lib; {
    description = "TensorFlow's Visualization Toolkit";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
