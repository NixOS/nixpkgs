{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "tensorboard_plugin_wit";
  version = "1.7.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    hash = "sha256-7ndfBIIRhckNmg6cVpcO5D18QUA762YpOFs5UXEpaFs=";
  };

  meta = {
    description = "What-If Tool TensorBoard plugin";
    homepage = "http://tensorflow.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
