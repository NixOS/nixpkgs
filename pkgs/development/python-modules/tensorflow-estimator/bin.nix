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
  version = "2.15.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_estimator";
    inherit version format;
    hash = "sha256-rt8h7sf7LckRUPyRoc4SvETbtyJ4oItY55/4fJ4o8VM=";
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
  };
}
