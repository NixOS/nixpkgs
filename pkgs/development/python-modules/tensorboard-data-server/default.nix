{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "tensorboard-data-server";
  version = "0.7.2";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorboard_data_server";
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-fgYQ0gWIlYiYODbsBdwJjoD5e357v/fplOu3j1eNDds=";
  };

  pythonImportsCheck = [ "tensorboard_data_server" ];

  meta = {
    description = "Fast data loading for TensorBoard";
    homepage = "https://github.com/tensorflow/tensorboard/tree/master/tensorboard/data/server";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
