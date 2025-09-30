{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tensorboard-data-server";
  version = "0.7.2";
  format = "wheel";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "tensorboard_data_server";
    inherit version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-fgYQ0gWIlYiYODbsBdwJjoD5e357v/fplOu3j1eNDds=";
  };

  pythonImportsCheck = [ "tensorboard_data_server" ];

  meta = with lib; {
    description = "Fast data loading for TensorBoard";
    homepage = "https://github.com/tensorflow/tensorboard/tree/master/tensorboard/data/server";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
