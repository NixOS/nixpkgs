{
  lib,
  fetchPypi,
  buildPythonPackage,
  numpy,
  absl-py,
  mock,
}:

buildPythonPackage rec {
  pname = "tensorflow-estimator";
  version = "2.11.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_estimator";
    inherit version format;
    hash = "sha256-6jtkrP/z2aJE8GF4yb3ty90/Eltn0IiNuoIpSY0GRos=";
  };

  propagatedBuildInputs = [
    mock
    numpy
    absl-py
  ];

  meta = with lib; {
    description = "TensorFlow Estimator is a high-level API that encapsulates model training, evaluation, prediction, and exporting";
    homepage = "http://tensorflow.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp ];
  };
}
