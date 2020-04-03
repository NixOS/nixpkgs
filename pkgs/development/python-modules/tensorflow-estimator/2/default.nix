{ stdenv, fetchPypi, buildPythonPackage
, numpy
, absl-py
, mock
}:

buildPythonPackage rec {
  pname = "tensorflow-estimator";
  version = "2.1.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_estimator";
    inherit version format;
    sha256 = "0wk9viil54ms1s2ir7zxygqa425i69hx8zngwhdqvw9nlr4gdig5";
  };

  propagatedBuildInputs = [ mock numpy absl-py ];

  meta = with stdenv.lib; {
    description = "TensorFlow Estimator is a high-level API that encapsulates model training, evaluation, prediction, and exporting.";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp ];
  };
}

