{ lib
, buildPythonPackage
, fetchPypi
, absl-py
, googleapis-common-protos
, protobuf
}:

buildPythonPackage rec {
  pname = "tensorflow-metadata";
  version = "0.30.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_metadata";
    inherit version;
    format = "wheel";
    python = "py3";
    sha256 = "074g6b2524w0rchvrpx1gmbybkw3mik0jg1xkzpkrqyq258bq1wh";
  };

  propagatedBuildInputs = [
    absl-py
    googleapis-common-protos
    protobuf
  ];

  pythonImportsCheck = [
    "tensorflow_metadata"
  ];

  meta = with lib; {
    description = "Utilities for passing TensorFlow-related metadata between tools";
    homepage = "https://github.com/tensorflow/metadata";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
