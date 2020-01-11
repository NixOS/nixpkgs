{ stdenv, fetchPypi, buildPythonPackage
, numpy
, absl-py 
, mock
}:

buildPythonPackage rec {
  pname = "tensorflow-estimator";
  # This is effectively 1.15.0. Upstream tagged 1.15.0 by mistake before actually updating the version in setup.py, which is why this tag is called 1.15.1.
  version = "1.15.1";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_estimator";
    inherit version format;
    sha256 = "1fc61wmc0w22frs79j2x4g6wnv5g21xc6rix1g4bsvy9qfvvylw8";
  };

  propagatedBuildInputs = [ mock numpy absl-py ];

  meta = with stdenv.lib; {
    description = "TensorFlow Estimator is a high-level API that encapsulates model training, evaluation, prediction, and exporting.";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp ];
  };
}

