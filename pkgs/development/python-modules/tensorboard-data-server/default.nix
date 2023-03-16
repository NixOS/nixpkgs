{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "tensorboard-data-server";
  version = "0.6.1";
  format = "wheel";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "tensorboard_data_server";
    inherit version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-gJ/piHaC01wffR9U8PQPmLsfdxsUJltFPKBR4s5Y/Kc=";
  };

  pythonImportsCheck = [ "tensorboard_data_server" ];

  meta = with lib; {
    description = "Fast data loading for TensorBoard";
    homepage = "https://github.com/tensorflow/tensorboard/tree/master/tensorboard/data/server";
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
