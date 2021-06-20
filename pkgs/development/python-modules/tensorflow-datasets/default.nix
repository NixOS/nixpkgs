{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, absl-py
, attrs
, dataclasses
, dill
, future
, importlib-resources
, numpy
, promise
, protobuf
, requests
, tensorflow
, tensorflow-metadata
, termcolor
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "tensorflow-datasets";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1g1ihlqsi5dxy1lrs7pli4cc33vjfb646frs9aq9qkmjk7arra4k";
  };

  propagatedBuildInputs = [
    absl-py
    attrs
    dill
    future
    numpy
    promise
    protobuf
    requests
    tensorflow
    tensorflow-metadata
    termcolor
    tqdm
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  pythonImportsCheck = [
    "tensorflow_datasets"
  ];

  # tests require apache_beam
  doCheck = false;

  meta = with lib; {
    description = "TFDS is a collection of datasets ready to use with TensorFlow, Jax, ...";
    homepage = "https://github.com/tensorflow/datasets";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
