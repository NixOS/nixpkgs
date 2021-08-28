{ lib, fetchPypi, buildPythonPackage
, numpy
, absl-py
, mock
}:

buildPythonPackage rec {
  pname = "tensorflow-estimator";
  version = "2.4.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_estimator";
    inherit version format;
    sha256 = "1w0pkcslm6934qqd6m5gxyjdlnb4pbl47k6s99wsh6dyvvr7nysv";
  };

  propagatedBuildInputs = [ mock numpy absl-py ];

  meta = with lib; {
    description = "TensorFlow Estimator is a high-level API that encapsulates model training, evaluation, prediction, and exporting.";
    homepage = "http://tensorflow.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp ];
  };
}

