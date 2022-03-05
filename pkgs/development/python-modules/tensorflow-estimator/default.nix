{ lib, fetchPypi, buildPythonPackage
, numpy
, absl-py
, mock
}:

buildPythonPackage rec {
  pname = "tensorflow-estimator";
  version = "2.7.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_estimator";
    inherit version format;
    hash = "sha256-MltaIkhkN5JCt7dsaYfKVEI5voJXnTPmjsfCvaV6vJ0=";
  };

  propagatedBuildInputs = [ mock numpy absl-py ];

  meta = with lib; {
    description = "TensorFlow Estimator is a high-level API that encapsulates model training, evaluation, prediction, and exporting.";
    homepage = "http://tensorflow.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp ];
  };
}

