{ stdenv, lib, fetchPypi, buildPythonPackage, isPy3k
, numpy
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
  version = "1.14.0";
  format = "wheel";

  src = fetchPypi ({
    pname = "tensorboard";
    inherit version;
    format = "wheel";
  } // (if isPy3k then {
    python = "py3";
    sha256 = "1z631614jk5zgasgmwfr33gz8bwv11p9f5llzlwvx3a8rnyv3q2h";
  } else {
    python = "py2";
    sha256 = "1clv29yy942l3mfar2z6wkkk6l18fz7j6mi2dfz24j9dln0scny3";
  }));

  propagatedBuildInputs = [
    numpy
    werkzeug
    protobuf
    markdown
    grpcio absl-py
  ] ++ lib.optional (!isPy3k) futures;

  meta = with stdenv.lib; {
    description = "TensorFlow's Visualization Toolkit";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
