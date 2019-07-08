{ stdenv, fetchPypi, buildPythonPackage
, numpy
, absl-py 
, mock
}:

buildPythonPackage rec {
  pname = "tensorflow-estimator";
  version = "1.14.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_estimator";
    inherit version format;
    sha256 = "14irpsyj14vn2dpwr601f54058wywci1pv0hss8s01rl0rk3y1ya";
  };

  propagatedBuildInputs = [ mock numpy absl-py ];

  meta = with stdenv.lib; {
    description = "TensorFlow Estimator is a high-level API that encapsulates model training, evaluation, prediction, and exporting.";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp ];
  };
}

