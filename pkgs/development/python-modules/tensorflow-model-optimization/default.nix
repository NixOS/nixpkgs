{
  lib,
  buildPythonPackage,
  fetchPypi,

  # dependencies
  tensorflow,
  tf-keras,
}:

buildPythonPackage rec {
  pname = "tensorflow-model-optimization";
  version = "0.8.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_model_optimization";
    inherit version format;
    hash = "sha256-UDA+btbQfBp4ASFfXMhU2tOI6o3jGeRnRso1eJ5O57M=";
  };

  dependencies = [
    tensorflow
    tf-keras
  ];

  pythonImportsCheck = [ "tensorflow_model_optimization" ];

  meta = with lib; {
    description = "A toolkit to optimize ML models for deployment for Keras and TensorFlow, including quantization and pruning.";
    homepage = "https://github.com/tensorflow/model-optimization";
    changelog = "https://github.com/tensorflow/model-optimization/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bachp ];
  };
}
