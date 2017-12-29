{ stdenv
, fetchPypi
, buildPythonPackage
, isPy3k
, bleach_1_5_0
, numpy
, werkzeug
, protobuf
, markdown
}:

# tensorflow is built from a downloaded wheel, because the upstream
# project's build system is an arcane beast based on
# bazel. Untangling it and building the wheel from source is an open
# problem.

buildPythonPackage rec {
  pname = "tensorflow-tensorboard";
  version = "0.1.5";
  name = "${pname}-${version}";
  format = "wheel";

  src = fetchPypi ({
    pname = "tensorflow_tensorboard";
    inherit version;
    format = "wheel";
  } // (if isPy3k then {
    python = "py3";
    sha256 = "0sfia05y1mzgy371faj96vgzhag1rgpa3gnbz9w1fay13jryw26x";
  } else {
    python = "py2";
    sha256 = "0qx4f55zp54x079kxir4zz5b1ckiglsdcb9afz5wcdj6af4a6czg";
  }));

  propagatedBuildInputs = [ bleach_1_5_0 numpy werkzeug protobuf markdown ];

  meta = with stdenv.lib; {
    description = "TensorFlow helps the tensors flow";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
