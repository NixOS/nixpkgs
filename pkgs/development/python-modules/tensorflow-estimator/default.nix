{ stdenv, lib, fetchPypi, buildPythonPackage, isPy3k
, numpy
, absl-py 
, mock
}:

buildPythonPackage rec {
  pname = "tensorflow-estimator";
  version = "1.13.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_estimator";
    inherit version format;
    sha256 = "068l4w0w7dj9gqkf8avjclq9zsp7ifwzw4rpf4qjylz3hczamzbw";
  };

  propagatedBuildInputs = [ mock numpy absl-py ];

  meta = with stdenv.lib; {
    description = "TensorFlow Estimator is a high-level API that encapsulates model training, evaluation, prediction, and exporting.";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp ];
  };
}

